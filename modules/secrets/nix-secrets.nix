{ inputs, ... }:
let
  # 个人 SSH 私钥只存在 yoga 上;其余机器一律只有 host key。
  # 写成显式名单而不是 pathExists:远程部署时评估机看不到目标机的 /home,
  # 判断会飘。新机器有了个人私钥就把 hostName 加进来。
  personalKeyHosts = [ "yoga" ];
in
{
  flake.modules.nixos.nix-secrets =
    { lib, config, ... }:
    {
      imports = [ inputs.omniflake.flakes.nix-secrets.nixosModules.default ];

      security.nix-secrets = {
        enable = true;
        storage = ./.; # 每个 secret 对应 <name>.enc,与 sops-secrets.nix 同目录

        # 身份文件:host key 来自本机 openssh 配置,个人私钥只给 personalKeyHosts。
        # 列出不存在的文件会让激活时拿不到身份,所以两台都只写真实存在的。
        identityPaths =
          map (key: key.path) (
            lib.filter (key: key.type == "rsa" || key.type == "ed25519") config.services.openssh.hostKeys
          )
          ++ lib.optionals (builtins.elem config.networking.hostName personalKeyHosts) [
            "/home/${config.myVars.user}/.ssh/id_ed25519"
          ];

        # 接收人就是各机/各用户的 SSH 公钥。加新机器:把公钥写进别名,
        # 再 `nix-secrets rekey --storage secrets` 重加密已有的 secret。
        recipientAliases = {
          yoga-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOaubBTa8qwJcVxuukrSQkEM3wQmaqI0RQHUyEADpz/7";
          yoga-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLrQVhdLD9o1Iq17LKFNQ21PaHIAylizOFkvh74FUrz";
          svp-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILG+NsVIumXxbc9SbV7VLMD4GOUPc9kCc+5cZuM2SNrs";
          yoga = [
            "yoga-host"
            "yoga-user"
          ];
        };

        secrets.dae_sub.recipients = [
          "yoga"
          "svp-host"
        ];
      };
    };
}
