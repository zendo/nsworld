{
  flake.modules.nixos.oci-papyra =
    { pkgs, ... }:
    {
      virtualisation.oci-containers.containers."papyra" = {
        image = "docker.io/lyfie/papyra:latest";
        autoStart = true;

        ports = [
          "3009:8080"
        ];

        volumes = [
          "/data/docs/papyra:/data"
        ];

        environment = {
          TZ = "Asia/Shanghai"; # "UTC"
          PUID = "1000";
          PGID = "1000";
          PAPYRA_ALLOW_INSECURE_COOKIES = "false";
        };

        # extraOptions = [
        #   "--health-cmd=wget -qO- http://localhost:8080/health"
        #   "--health-interval=30s"
        #   "--health-timeout=5s"
        #   "--health-start-period=20s"
        #   "--health-retries=3"
        # ];
      };

      # 注意：compose 中的命名卷（papyra-data）在 oci-containers 中通常映射为宿主机路径
      # 或者依赖 Podman/Docker 自动管理。如果希望指定宿主机路径，将上面的 volumes 改为类似：
      # volumes = [ "/var/lib/papyra-data:/data" ];
    };
}
