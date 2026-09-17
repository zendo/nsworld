#!/usr/bin/env node

// node sing-box-merge.js sb-template.json all

const fs = require("fs");

const [, , templateFile, nodesFile] = process.argv;

const config = JSON.parse(fs.readFileSync(templateFile, "utf8"));
const nodes = JSON.parse(fs.readFileSync(nodesFile, "utf8"));

const outbounds = config.outbounds ??= [];
const nodesOutbounds = nodes.outbounds ?? [];
const nodeTags = nodesOutbounds.map((out) => out.tag).filter(Boolean);

outbounds.push(...nodesOutbounds);

for (const tag of ["🎈 自动选择", "🚀 节点选择"]) {
  const selector = outbounds.find((out) => out.tag === tag);

  if (Array.isArray(selector?.outbounds)) {
    selector.outbounds.push(...nodeTags);
  }
}

fs.writeFileSync(
  "config.jsonc",
  JSON.stringify(config, null, 2) + "\n"
);
