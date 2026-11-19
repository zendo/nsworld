{ inputs, ... }:
let
  sopsSecrets = {
    dae_sub = { };
  };

  secret-apps =
    pkgs: with pkgs; [
      age
      # rage # age RIIR
      ssh-to-age
      # ragenix # agenix
      sops
    ];
in
{
  # 和下面的 sops-nix 模块互不依赖：哪个 host 要试就在它的模块列表里加
  # `nix-secrets`，不加不影响现有链路。identityPaths 直接用机器自己的 SSH key，
  # 不需要往机器上额外放 age 私钥文件。
  flake.modules.nixos.nix-secrets =
    {
      lib,
      config,
      options,
      ...
    }:
    {
      imports = [ inputs.omniflake.flakes.nix-secrets.nixosModules.default ];

      security.nix-secrets = {
        enable = true;
        storage = ../secrets; # 每个 secret 对应 secrets/<name>.enc

        # 列出本机真实存在的身份文件：openssh 没开的机器不写 host key，
        # 没有 myvars 的机器不猜用户名，否则激活时找不到文件会报错。
        identityPaths =
          map (key: key.path) (
            lib.filter (key: key.type == "rsa" || key.type == "ed25519") config.services.openssh.hostKeys
          )
          ++ lib.optionals (options ? myVars) [
            "/home/${config.myVars.user}/.ssh/id_ed25519"
          ];

        # 接收人就是各机/各用户的 SSH 公钥。加新机器：把公钥写进别名，
        # 再 `nix-secrets rekey --storage secrets` 重加密已有的 secret。
        recipientAliases = {
          yoga-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOaubBTa8qwJcVxuukrSQkEM3wQmaqI0RQHUyEADpz/7";
          yoga-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLrQVhdLD9o1Iq17LKFNQ21PaHIAylizOFkvh74FUrz";
          yoga = [
            "yoga-host"
            "yoga-user"
          ];
        };

        secrets.dae_sub.recipients = [ "yoga" ];
      };
    };

  flake.modules.nixos.secrets =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.omniflake.flakes.sops-nix.nixosModules.sops ];

      sops.secrets = sopsSecrets;
      sops.defaultSopsFile = ./sopsnix.yaml;
      # Copy: https://github.com/ryantm/agenix/blob/main/modules/age.nix#L241
      sops.age.sshKeyPaths = map (e: e.path) (
        lib.filter (e: e.type == "rsa" || e.type == "ed25519") config.services.openssh.hostKeys
      );

      environment.systemPackages = secret-apps pkgs;
    };

  flake.modules.homeManager.secrets =
    { config, pkgs, ... }:
    {
      imports = [ inputs.omniflake.flakes.sops-nix.homeManagerModules.sops ];

      sops.secrets = sopsSecrets;
      sops.defaultSopsFile = ./sopsnix.yaml;
      sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

      home.packages = secret-apps pkgs;
    };

  perSystem =
    { pkgs, ... }:
    {
      devshells.nsw-secrets = {
        packages = secret-apps pkgs;
        commands = [
          {
            name = "secrets-hostkey-to-age";
            command = ''
              KEY_FILE="$HOME/.config/sops/age/keys.txt"
              SSH_KEY="/var/lib/ssh/ssh_host_ed25519_key"
              echo "=> Preparing age host-key"
              if [ -f "$KEY_FILE" ]; then
                  echo "Age key already exists. Skipping..."
              else
                  mkdir -p "$(dirname "$KEY_FILE")"
                  sudo ssh-to-age -private-key -i "$SSH_KEY" -o "$KEY_FILE"
                  sudo chown "$(id -u):$(id -g)" "$KEY_FILE"
              fi
              echo "Public Key ssh/age:"
              cat "''${SSH_KEY}.pub"
              ssh-to-age < "''${SSH_KEY}.pub"
            '';
          }
        ];
      };
    };
}
