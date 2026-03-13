{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        # --- 1. 保持连接（防掉线） ---
        serverAliveInterval = 60; # 每 60 秒发一次心跳包
        serverAliveCountMax = 5; # 连续 5 次没响应才断开
        # --- 2. 自动化密钥管理 ---
        addKeysToAgent = "yes"; # 第一次解密私钥后，自动存入 ssh-agent
        forwardAgent = false; # 默认关闭转发，仅在特定 host 下开启
        # --- 3. 连接多路复用（秒连神器） ---
        # 第一次连接会建立 Master，后续连接同一台机器将直接复用，无需握手
        controlMaster = "auto";
        controlPersist = "30m"; # 主连接关闭后，后台保持 30 分钟
        controlPath = "~/.ssh/master-%r@%n:%p";
        # --- 4. 性能与安全性平衡 ---
        # hashKnownHosts = true; # 开启哈希，保护你的 known_hosts 不被扫描
        # --- 5. 现代加密偏好 ---
        extraOptions = {
          # 优先使用更安全的算法
          "HostKeyAlgorithms" = "ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-256";
          # 避免连接时弹出一堆无用的私钥尝试
          "IdentitiesOnly" = "yes";
        };
      };
      "github.com" = {
        hostname = "ssh.github.com";
        port = 443;
        # 很多机场禁用 22 端口，代理一样无法连接
        # proxyCommand = "nc -X 5 -x 127.0.0.1:7890 %h %p";
      };
      yoga = {
        hostname = "192.168.2.218";
        port = 22;
      };
      svp = {
        hostname = "192.168.2.30";
        port = 22;
      };
      rmt = {
        hostname = "192.168.122.86";
        port = 22;
        forwardAgent = true; # TODO
      };
    };
    extraConfig = ''
      Host example1
        HostName 192.168.122.247
        Port 22
        User root
    '';
  };
}
