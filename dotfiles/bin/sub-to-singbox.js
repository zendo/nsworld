#!/usr/bin/env node

// sub-to-singbox.js - 抓订阅（mihomo/clash 的 yaml）并把 proxies 转成 sing-box outbounds
//
//   node sub-to-singbox.js <url|file> [out.json]
//   node sing-box-merge.js sing-box-template.json nodes.json     # 再跑这一步
//
// 输出形如 { outbounds: [...] }，就是 sing-box-merge.js 期待的节点文件。
// 依赖: node + yq（YAML -> JSON；这里不用 npm 包，避免 node_modules 从哪来的问题）

const fs = require("fs");
const { execFileSync } = require("child_process");

const UA = process.env.SUB_UA ?? "clash.meta"; // 很多机场靠 UA 决定给不给 clash yaml
const [, , src, outFile = "nodes.json"] = process.argv;

// kebab-case / snake_case / camelCase 都认，mihomo 各版本字段名不统一
const get = (o, ...keys) => {
  for (const k of keys) if (o?.[k] !== undefined) return o[k];
  return undefined;
};
const pick = (obj) => Object.fromEntries(Object.entries(obj).filter(([, v]) => v !== undefined));
// sing-box 的 reality public_key 只认 url-safe 无填充 base64，机场给的经常是带 '='/'+'/'/' 的标准 base64
const b64url = (s) => Buffer.from(String(s), "base64").toString("base64url");

async function readSource(s) {
  if (/^https?:\/\//i.test(s)) {
    const r = await fetch(s, { headers: { "user-agent": UA } });
    if (!r.ok) throw new Error(`${s} -> HTTP ${r.status}`);
    return await r.text();
  }
  return fs.readFileSync(s, "utf8");
}

function parseDoc(text) {
  let t = text.trim();
  // 有的机场整段 base64 包一层
  if (!t.startsWith("{") && !t.startsWith("[") && /^[A-Za-z0-9+/=\r\n]+$/.test(t) && t.length > 64) {
    t = Buffer.from(t.replace(/\s+/g, ""), "base64").toString("utf8").trim();
  }
  if (t.startsWith("{")) return JSON.parse(t); // 已经是 sing-box 节点文件
  // YAML 交给 yq（mikefarah v4），node 24 没有内置 YAML 解析
  return JSON.parse(execFileSync("yq", ["-o=json", "."], { input: t, maxBuffer: 64 << 20 }).toString());
}

// 节点可能内联在 proxies，也可能在 proxy-providers 指向的订阅里
async function collectProxies(doc, seen = new Set()) {
  const nodes = [];
  for (const p of doc?.proxies ?? []) nodes.push(p);

  for (const [id, prov] of Object.entries(doc?.["proxy-providers"] ?? {})) {
    const url = get(prov, "url");
    if (!url || seen.has(url)) continue;
    seen.add(url);
    const prefix = get(prov?.override, "additional-prefix") ?? "";
    const sub = parseDoc(await readSource(url));
    for (const p of await collectProxies(sub, seen)) {
      nodes.push({ ...p, name: prefix + (p.name ?? "") });
    }
    process.stderr.write(`  provider ${id}: ${(sub.proxies ?? []).length} 个节点 ${url.replace(/^(https?:\/\/[^/]+).*/, "$1/…")}\n`);
  }
  return nodes;
}

function tlsOf(p, force = false) {
  const sni = get(p, "servername", "sni", "server-name");
  const insecure = !!(get(p, "skip-cert-verify", "allow-insecure"));
  const reality = p["reality-opts"];
  if (!(p.tls || force || reality || insecure)) return undefined;
  const t = pick({
    enabled: true,
    server_name: sni,
    insecure: insecure || undefined,
    alpn: p.alpn,
    // mihomo 的 client-fingerprint -> sing-box 的 utls
    utls: p["client-fingerprint"] ? { enabled: true, fingerprint: p["client-fingerprint"] } : undefined,
    reality: reality
      ? pick({
          enabled: true,
          public_key: b64url(get(reality, "public-key", "public_key")),
          short_id: get(reality, "short-id", "short_id"),
        })
      : undefined,
  });
  return t;
}

function transportOf(p) {
  const net = get(p, "network", "net");
  if (!net || net === "tcp") return undefined;

  if (net === "ws" || net === "httpupgrade") {
    const o = p["ws-opts"] ?? {};
    return pick({
      type: net,
      path: o.path,
      headers: o.headers,
      max_early_data: get(o, "max-early-data"),
      early_data_header_name: get(o, "early-data-header-name"),
    });
  }
  if (net === "grpc") {
    return pick({ type: "grpc", service_name: get(p["grpc-opts"], "grpc-service-name") });
  }
  if (net === "h2") {
    const o = p["h2-opts"] ?? {};
    return pick({ type: "http", host: o.host, path: o.path });
  }
  if (net === "http") {
    const o = p["http-opts"] ?? {};
    return pick({ type: "http", host: get(o.headers, "Host", "host"), path: o.path?.[0] });
  }
  return undefined;
}

// 端口范围写法不同：mihomo 用 "20000-50000"，sing-box 只认 "20000:50000"
function portRanges(p) {
  const v = get(p, "ports", "server_ports");
  if (v === undefined) return undefined;
  const list = Array.isArray(v) ? v : String(v).split(",");
  return list.map((s) => String(s).trim().replace(/\s*[-~]\s*/, ":")).filter(Boolean);
}

// hysteria2 的 obfs: mihomo 里可能是 { type, password }，也可能只是字符串 + obfs-password
function obfsOf(p) {
  const o = p.obfs;
  const pw = get(p, "obfs-password", "obfs_password");
  if (typeof o === "string") return pick({ type: o, password: pw });
  if (o && typeof o === "object") return pick({ type: get(o, "type"), password: get(o, "password") });
  return pw ? { type: "salamander", password: pw } : undefined;
}

function multiplexOf(p) {
  const m = get(p, "smux");
  if (!m || m.enabled === false) return undefined;
  return pick({
    enabled: true,
    protocol: m.protocol,
    max_streams: get(m, "max-connections", "max_streams"),
    padding: m.padding,
  });
}

// mihomo 的 ss plugin -> sing-box 的 plugin / plugin_opts 字符串
function ssPlugin(p) {
  const plugin = p.plugin;
  const o = get(p, "plugin-opts") ?? {};
  if (plugin === "obfs") {
    const opts = [`obfs=${o.mode ?? "http"}`];
    if (o.host) opts.push(`obfs-host=${o.host}`);
    return { plugin: "obfs-local", plugin_opts: opts.join(";") };
  }
  if (plugin === "v2ray-plugin") {
    const opts = [`mode=${o.mode ?? "websocket"}`];
    if (o.host) opts.push(`host=${o.host}`);
    if (o.path) opts.push(`path=${o.path}`);
    if (o.tls) opts.push("tls");
    return { plugin: "v2ray-plugin", plugin_opts: opts.join(";") };
  }
  return {};
}

const base = (p, type) => pick({ type, tag: p.name, server: p.server, server_port: get(p, "port", "server_port") });

const builders = {
  ss(p) {
    return pick({
      ...base(p, "shadowsocks"),
      method: get(p, "cipher", "method"),
      password: p.password,
      ...ssPlugin(p),
      udp_over_tcp: p["udp-over-tcp"] ? { enabled: true, version: get(p, "udp-over-tcp-version") } : undefined,
    });
  },
  vmess(p) {
    return pick({
      ...base(p, "vmess"),
      uuid: p.uuid,
      security: get(p, "cipher", "security") ?? "auto",
      alter_id: get(p, "alterId", "alter-id", "alter_id") ?? 0,
      global_padding: p["global-padding"],
      authenticated_length: p["authenticated-length"],
      transport: transportOf(p),
      tls: tlsOf(p),
      multiplex: multiplexOf(p),
    });
  },
  vless(p) {
    return pick({
      ...base(p, "vless"),
      uuid: p.uuid,
      flow: p.flow,
      packet_encoding: get(p, "packet-encoding", "packet_encoding"),
      transport: transportOf(p),
      tls: tlsOf(p),
      multiplex: multiplexOf(p),
    });
  },
  trojan(p) {
    return pick({
      ...base(p, "trojan"),
      password: p.password,
      transport: transportOf(p),
      tls: tlsOf(p, true),
      multiplex: multiplexOf(p),
    });
  },
  hysteria2(p) {
    return pick({
      ...base(p, "hysteria2"),
      password: p.password,
      server_ports: portRanges(p),
      up_mbps: get(p, "up", "up-mbps"),
      down_mbps: get(p, "down", "down-mbps"),
      obfs: obfsOf(p),
      tls: tlsOf(p, true),
    });
  },
  hysteria(p) {
    return pick({
      ...base(p, "hysteria"),
      server_ports: portRanges(p),
      auth_str: get(p, "auth-str", "auth_str", "auth"),
      up_mbps: get(p, "up", "up-mbps"),
      down_mbps: get(p, "down", "down-mbps"),
      obfs: get(p, "obfs"),
      protocol: p.protocol,
      tls: tlsOf(p, true),
    });
  },
  tuic(p) {
    return pick({
      ...base(p, "tuic"),
      uuid: p.uuid,
      password: p.password,
      congestion_control: get(p, "congestion-controller", "congestion_control"),
      udp_relay_mode: get(p, "udp-relay-mode", "udp_relay_mode"),
      heartbeat: get(p, "heartbeat-interval"),
      tls: tlsOf(p, true),
    });
  },
  anytls(p) {
    return pick({ ...base(p, "anytls"), password: p.password, tls: tlsOf(p, true) });
  },
  socks5(p) {
    return pick({
      ...base(p, "socks"),
      username: p.username,
      password: p.password,
      udp_over_tcp: p["udp-over-tcp"] ? { enabled: true } : undefined,
    });
  },
  http(p) {
    return pick({ ...base(p, "http"), username: p.username, password: p.password, tls: tlsOf(p) });
  },
  direct(p) {
    return { type: "direct", tag: p.name }; // mihomo 的直连节点（带 ip-version 的一律忽略）
  },
};

// sing-box 没有对应实现的类型：跳过而不是产出坏配置
const UNSUPPORTED = { ssr: "shadowsocksr 不被 sing-box 支持", snell: "snell 不被 sing-box 支持", wireguard: "wireguard 在 1.11+ 是 endpoint，不属于 outbounds" };

function convert(proxies) {
  const out = [];
  const tags = new Set();
  const skipped = [];

  for (const p of proxies) {
    const type = String(p?.type ?? "").toLowerCase();
    const build = builders[type];
    if (!build) {
      skipped.push(`${p?.name} (${type || "无 type"})：${UNSUPPORTED[type] ?? "未知类型"}`);
      continue;
    }
    if (!p.name) {
      skipped.push(`${type}@${p.server}：没有 name`);
      continue;
    }

    const ob = build(p);
    // sing-box 要求 tag 唯一，机场重名很常见
    let tag = ob.tag;
    for (let i = 2; tags.has(tag); i++) tag = `${ob.tag} #${i}`;
    tags.add(tag);
    out.push({ ...ob, tag });
  }
  return { outbounds: out, skipped };
}

(async () => {
  if (!src) {
    process.stderr.write("usage: sub-to-singbox.js <url|file> [out.json]\n");
    process.exit(1);
  }

  const doc = parseDoc(await readSource(src));

  // 已经是 sing-box 节点文件（有 outbounds 没有 proxies）：原样转发
  if (Array.isArray(doc?.outbounds) && !doc.proxies) {
    fs.writeFileSync(outFile, JSON.stringify({ outbounds: doc.outbounds }, null, 2) + "\n");
    process.stderr.write(`  已是 sing-box 格式，${doc.outbounds.length} 个 outbounds -> ${outFile}\n`);
    return;
  }

  const proxies = await collectProxies(doc);
  const { outbounds, skipped } = convert(proxies);

  for (const s of skipped) process.stderr.write(`  skip ${s}\n`);
  process.stderr.write(`  转换 ${outbounds.length} 个，跳过 ${skipped.length} 个 -> ${outFile}\n`);

  fs.writeFileSync(outFile, JSON.stringify({ outbounds }, null, 2) + "\n");
})().catch((e) => {
  process.stderr.write(`sub-to-singbox: ${e.message}\n`);
  process.exit(1);
});
