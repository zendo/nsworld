{
  flake.modules.nixos.mods =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      inherit (lib)
        mkEnableOption
        mkIf
        mkOption
        types
        ;

      cfg = config.boot.loader.sprout;
      efi = config.boot.loader.efi;

      sproutInstaller = pkgs.replaceVarsWith {
        name = "sprout-install";
        src = ./sprout-install.py;
        isExecutable = true;

        postCheck = ''
          ${lib.getExe pkgs.buildPackages.mypy} \
            --no-implicit-optional \
            --disallow-untyped-calls \
            --disallow-untyped-defs \
            "$target"
        '';

        replacements = {
          inherit (pkgs) python3;

          nix = config.nix.package.out;
          efibootmgr = pkgs.efibootmgr;
          util-linux = pkgs.util-linuxMinimal;

          efiSysMountPoint = toString efi.efiSysMountPoint;
          sproutBinary = "${cfg.package}/lib/sprout/sprout.efi";

          timeout =
            if config.boot.loader.timeout == null then
              throw ''
                boot.loader.sprout requires boot.loader.timeout to be non-null.
                Sprout's native configuration format currently has no equivalent
                for NixOS's null timeout.
              ''
            else
              toString config.boot.loader.timeout;

          configurationLimit =
            if cfg.configurationLimit == null then "0" else toString cfg.configurationLimit;

          canTouchEfiVariables = if efi.canTouchEfiVariables then "1" else "0";

          efiInstallAsRemovable = if cfg.efiInstallAsRemovable then "1" else "0";

          firmwareEntryLabel = builtins.toJSON cfg.firmwareEntryLabel;

          drivers = builtins.toJSON (lib.mapAttrs (_name: path: toString path) cfg.drivers);
        };
      };

    in
    {
      options.boot.loader.sprout = {
        enable = mkEnableOption "Sprout bootloader";

        package = mkOption {
          type = types.package;
          default = pkgs.sprout;
          defaultText = lib.literalExpression "pkgs.sprout";
          description = ''
            The Sprout EFI bootloader package.

            The package must provide the bootloader executable at
            `lib/sprout/sprout.efi`.
          '';
        };

        configurationLimit = mkOption {
          type = types.nullOr types.int;
          default = null;
          example = 10;
          description = ''
            Maximum number of NixOS generations retained in the Sprout boot menu.

            `null` means all generations that have not been garbage collected.
          '';
        };

        efiInstallAsRemovable = mkOption {
          type = types.bool;
          default = !efi.canTouchEfiVariables;
          defaultText = lib.literalExpression "!config.boot.loader.efi.canTouchEfiVariables";
          description = ''
            Also install Sprout as the UEFI removable-media fallback loader.

            On x86_64 this installs `EFI/BOOT/BOOTX64.EFI`.
            On aarch64 this installs `EFI/BOOT/BOOTAA64.EFI`.
          '';
        };

        firmwareEntryLabel = mkOption {
          type = types.str;
          default = "NixOS Sprout";
          description = ''
            Label used for the UEFI NVRAM boot entry created for Sprout.
          '';
        };

        drivers = mkOption {
          type = types.attrsOf types.path;
          default = { };
          example = lib.literalExpression ''
            {
              btrfs = pkgs.btrfs-efi-driver;
            }
          '';
          description = ''
            EFI drivers to install for Sprout.

            Each attribute name becomes the Sprout driver name and the installed
            filename under `EFI/Sprout/drivers/`.
          '';
        };
      };

      config = mkIf cfg.enable {
        boot.loader.grub.enable = lib.mkDefault false;

        boot.loader.supportsInitrdSecrets = true;

        system.boot.loader.id = "sprout";

        system.build.installBootLoader = sproutInstaller;

        system.requiredKernelConfig = with config.lib.kernelConfig; [
          (isYes "EFI_STUB")
        ];

        assertions = [
          {
            assertion = cfg.efiInstallAsRemovable || efi.canTouchEfiVariables;

            message = ''
              boot.loader.sprout.efiInstallAsRemovable must be enabled when
              boot.loader.efi.canTouchEfiVariables is false.
            '';
          }

          {
            assertion = (config.boot.kernelPackages.kernel.features or { efiBootStub = true; }) ? efiBootStub;

            message = ''
              Sprout requires an EFI-stub-capable kernel.
            '';
          }

          {
            assertion = cfg.configurationLimit == null || cfg.configurationLimit >= 0;

            message = ''
              boot.loader.sprout.configurationLimit must be null or non-negative.
            '';
          }

          {
            assertion = config.boot.loader.timeout != null && config.boot.loader.timeout >= 0;

            message = ''
              boot.loader.timeout must be non-null and non-negative. Sprout does not
              support null / an indefinitely displayed boot menu.
            '';
          }
        ];
      };
    };
}
