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

      normalizedSettings = {
        options = lib.filterAttrs (_k: v: v != null) cfg.settings.options;
        entries = lib.mapAttrs (
          _name: entry:
          {
            inherit (entry) title actions values;
          }
          // (lib.optionalAttrs (entry.sort-key != null) {
            inherit (entry) sort-key;
          })
        ) cfg.settings.entries;
        actions = lib.mapAttrs (
          _name: action:
          if action.chainload != null then
            {
              chainload = {
                inherit (action.chainload) path;
              }
              // (lib.optionalAttrs (action.chainload.options != [ ]) {
                inherit (action.chainload) options;
              })
              // (lib.optionalAttrs (action.chainload.linux-initrd != null) {
                inherit (action.chainload) linux-initrd;
              })
              // (lib.optionalAttrs (action.chainload.linux-initrd-chain != [ ]) {
                inherit (action.chainload) linux-initrd-chain;
              });
            }
          else if action.print != null then
            {
              print = {
                inherit (action.print) text;
              };
            }
          else if action.edera != null then
            {
              edera = {
                inherit (action.edera) xen kernel;
              }
              // (lib.optionalAttrs (action.edera.initrd != null) {
                inherit (action.edera) initrd;
              })
              // (lib.optionalAttrs (action.edera.initrd-chain != [ ]) {
                inherit (action.edera) initrd-chain;
              })
              // (lib.optionalAttrs (action.edera.kernel-options != [ ]) {
                inherit (action.edera) kernel-options;
              })
              // (lib.optionalAttrs (action.edera.xen-options != [ ]) {
                inherit (action.edera) xen-options;
              });
            }
          else
            { }
        ) cfg.settings.actions;
      }
      // (lib.optionalAttrs (cfg.settings.values != { }) {
        inherit (cfg.settings) values;
      })
      // (lib.optionalAttrs
        (
          cfg.settings.phases.early != [ ]
          || cfg.settings.phases.startup != [ ]
          || cfg.settings.phases.late != [ ]
        )
        {
          phases = {
            early = map (item: { inherit (item) actions values; }) cfg.settings.phases.early;
            startup = map (item: { inherit (item) actions values; }) cfg.settings.phases.startup;
            late = map (item: { inherit (item) actions values; }) cfg.settings.phases.late;
          };
        }
      );

      settingsJsonFile = pkgs.writeText "sprout-settings.json" (builtins.toJSON normalizedSettings);

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

          extraFiles = builtins.toJSON (lib.mapAttrs (_name: path: toString path) cfg.extraFiles);

          settingsFile = settingsJsonFile;
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

        extraFiles = mkOption {
          type = types.attrsOf types.path;
          default = { };
          example = lib.literalExpression ''
            {
              memtest = pkgs.memtest86plus + "/memtest.efi";
            }
          '';
          description = ''
            Custom EFI files to install for Sprout.

            Each attribute name is a stable logical identifier matching
            `[A-Za-z_][A-Za-z0-9_]*`. The attribute value must be an individual
            file path, not a package directory.

            Each file is installed under a deterministic content-addressed path
            in `EFI/Sprout/extra-files/` and exposed in `sprout.toml` through a
            root value named `sprout_extra_file_<name>`.
          '';
        };

        settings = mkOption {
          type = types.submodule {
            options = {
              options = mkOption {
                type = types.submodule {
                  options = {
                    menu-style = mkOption {
                      type = types.nullOr (
                        types.enum [
                          "simple"
                          "basic"
                        ]
                      );
                      default = null;
                      description = ''
                        Sprout menu style: "simple" or "basic".
                      '';
                    };
                  };
                };
                default = { };
                description = ''
                  Static Sprout menu options.
                '';
              };

              entries = mkOption {
                type = types.attrsOf (
                  types.submodule (
                    { name, ... }: {
                      options = {
                        title = mkOption {
                          type = types.str;
                          description = ''
                            The entry title.
                          '';
                        };

                        actions = mkOption {
                          type = types.listOf types.str;
                          description = ''
                            List of action identifiers. Must be non-empty.
                          '';
                        };

                        sort-key = mkOption {
                          type = types.nullOr types.str;
                          default = null;
                          description = ''
                            Optional sort key for ordering the entry.
                          '';
                        };

                        values = mkOption {
                          type = types.attrsOf types.str;
                          default = { };
                          description = ''
                            Entry-specific values table.
                          '';
                        };
                      };
                    }
                  )
                );
                default = { };
                description = ''
                  Static Sprout boot entries.
                '';
              };

              actions = mkOption {
                type = types.attrsOf (
                  types.submodule (
                    { name, ... }: {
                      options = {
                        chainload = mkOption {
                          type = types.nullOr (
                            types.submodule {
                              options = {
                                path = mkOption {
                                  type = types.str;
                                  description = ''
                                    Path to the EFI binary to chainload.
                                  '';
                                };

                                options = mkOption {
                                  type = types.listOf types.str;
                                  default = [ ];
                                  description = ''
                                    Command-line arguments passed to the chainloaded EFI binary.
                                  '';
                                };

                                linux-initrd = mkOption {
                                  type = types.nullOr types.str;
                                  default = null;
                                  description = ''
                                    Path to a single Linux initrd. Mutually exclusive with `linux-initrd-chain`.
                                  '';
                                };

                                linux-initrd-chain = mkOption {
                                  type = types.listOf types.str;
                                  default = [ ];
                                  description = ''
                                    List of paths to Linux initrds. Mutually exclusive with `linux-initrd`.
                                  '';
                                };
                              };
                            }
                          );
                          default = null;
                          description = ''
                            Chainload action variant.
                          '';
                        };

                        print = mkOption {
                          type = types.nullOr (
                            types.submodule {
                              options = {
                                text = mkOption {
                                  type = types.str;
                                  default = "";
                                  description = ''
                                    Text to print to the console.
                                  '';
                                };
                              };
                            }
                          );
                          default = null;
                          description = ''
                            Print action variant.
                          '';
                        };

                        edera = mkOption {
                          type = types.nullOr (
                            types.submodule {
                              options = {
                                xen = mkOption {
                                  type = types.str;
                                  description = ''
                                    Path to the Xen hypervisor binary.
                                  '';
                                };

                                kernel = mkOption {
                                  type = types.str;
                                  description = ''
                                    Path to the kernel binary.
                                  '';
                                };

                                initrd = mkOption {
                                  type = types.nullOr types.str;
                                  default = null;
                                  description = ''
                                    Path to a single initrd. Mutually exclusive with `initrd-chain`.
                                  '';
                                };

                                initrd-chain = mkOption {
                                  type = types.listOf types.str;
                                  default = [ ];
                                  description = ''
                                    List of paths to initrds. Mutually exclusive with `initrd`.
                                  '';
                                };

                                kernel-options = mkOption {
                                  type = types.listOf types.str;
                                  default = [ ];
                                  description = ''
                                    Command-line arguments passed to the kernel.
                                  '';
                                };

                                xen-options = mkOption {
                                  type = types.listOf types.str;
                                  default = [ ];
                                  description = ''
                                    Command-line arguments passed to Xen.
                                  '';
                                };
                              };
                            }
                          );
                          default = null;
                          description = ''
                            Edera action variant.
                          '';
                        };
                      };
                    }
                  )
                );
                default = { };
                description = ''
                  Static Sprout action definitions.
                '';
              };

              phases = mkOption {
                type = types.submodule {
                  options = {
                    early = mkOption {
                      type = types.listOf (
                        types.submodule {
                          options = {
                            actions = mkOption {
                              type = types.listOf types.str;
                              description = ''
                                List of action identifiers. Must be non-empty.
                              '';
                            };

                            values = mkOption {
                              type = types.attrsOf types.str;
                              default = { };
                              description = ''
                                Phase-local string values.
                              '';
                            };
                          };
                        }
                      );
                      default = [ ];
                      description = ''
                        Actions to run before drivers load.
                      '';
                    };

                    startup = mkOption {
                      type = types.listOf (
                        types.submodule {
                          options = {
                            actions = mkOption {
                              type = types.listOf types.str;
                              description = ''
                                List of action identifiers. Must be non-empty.
                              '';
                            };

                            values = mkOption {
                              type = types.attrsOf types.str;
                              default = { };
                              description = ''
                                Phase-local string values.
                              '';
                            };
                          };
                        }
                      );
                      default = [ ];
                      description = ''
                        Actions to run after drivers load and before the boot menu is built.
                      '';
                    };

                    late = mkOption {
                      type = types.listOf (
                        types.submodule {
                          options = {
                            actions = mkOption {
                              type = types.listOf types.str;
                              description = ''
                                List of action identifiers. Must be non-empty.
                              '';
                            };

                            values = mkOption {
                              type = types.attrsOf types.str;
                              default = { };
                              description = ''
                                Phase-local string values.
                              '';
                            };
                          };
                        }
                      );
                      default = [ ];
                      description = ''
                        Actions to run after an entry is selected and before its actions run.
                      '';
                    };
                  };
                };
                default = { };
                description = ''
                  Static Sprout boot phases.
                '';
              };

              values = mkOption {
                type = types.attrsOf types.str;
                default = { };
                description = ''
                  Shared default root-level values for variable expansion in Sprout configuration.
                  May be overridden by narrower entry- or phase-local values according to Sprout's value semantics.
                '';
              };
            };
          };
          default = { };
          description = ''
            Static Sprout configuration settings. Exposes a closed, typed subset of Sprout's
            configuration schema for static menu options, additional entries, actions, phases, and root values.
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

          {
            assertion = !lib.hasAttr "" cfg.settings.entries;

            message = ''
              boot.loader.sprout.settings.entries cannot contain an empty entry name.
            '';
          }

          {
            assertion = !lib.hasAttr "" cfg.settings.actions;

            message = ''
              boot.loader.sprout.settings.actions cannot contain an empty action name.
            '';
          }

          {
            assertion = lib.all (name: !lib.hasPrefix "nixos-" name) (lib.attrNames cfg.settings.entries);

            message = ''
              boot.loader.sprout.settings.entries cannot use reserved 'nixos-' prefix.
            '';
          }

          {
            assertion = lib.all (name: !lib.hasPrefix "nixos-" name) (lib.attrNames cfg.settings.actions);

            message = ''
              boot.loader.sprout.settings.actions cannot use reserved 'nixos-' prefix.
            '';
          }

          {
            assertion = lib.all (entry: entry.actions != [ ]) (lib.attrValues cfg.settings.entries);

            message = ''
              boot.loader.sprout.settings.entries.<name>.actions must be non-empty.
            '';
          }

          {
            assertion = lib.all (entry: lib.all (act: lib.hasAttr act cfg.settings.actions) entry.actions) (
              lib.attrValues cfg.settings.entries
            );

            message = ''
              All actions referenced by boot.loader.sprout.settings.entries must exist in boot.loader.sprout.settings.actions.
            '';
          }

          {
            assertion = lib.all (
              action:
              let
                variants =
                  (if action.chainload != null then 1 else 0)
                  + (if action.print != null then 1 else 0)
                  + (if action.edera != null then 1 else 0);
              in
              variants == 1
            ) (lib.attrValues cfg.settings.actions);

            message = ''
              Each action in boot.loader.sprout.settings.actions must define exactly one variant (chainload, print, or edera).
            '';
          }

          {
            assertion = lib.all (
              action:
              action.chainload == null
              || action.chainload.linux-initrd == null
              || action.chainload.linux-initrd-chain == [ ]
            ) (lib.attrValues cfg.settings.actions);

            message = ''
              boot.loader.sprout.settings.actions.<name>.chainload cannot specify both 'linux-initrd' and 'linux-initrd-chain'.
            '';
          }

          {
            assertion = lib.all (
              action: action.edera == null || action.edera.initrd == null || action.edera.initrd-chain == [ ]
            ) (lib.attrValues cfg.settings.actions);

            message = ''
              boot.loader.sprout.settings.actions.<name>.edera cannot specify both 'initrd' and 'initrd-chain'.
            '';
          }

          {
            assertion = lib.all (name: builtins.match "[A-Za-z_][A-Za-z0-9_]*" name != null) (
              lib.attrNames cfg.extraFiles
            );

            message = ''
              boot.loader.sprout.extraFiles attribute names must match [A-Za-z_][A-Za-z0-9_]*.
            '';
          }

          {
            assertion = lib.all (
              entry: lib.all (key: !lib.hasPrefix "sprout_extra_file_" key) (lib.attrNames entry.values)
            ) (lib.attrValues cfg.settings.entries);

            message = ''
              boot.loader.sprout.settings.entries.<name>.values cannot use reserved 'sprout_extra_file_' prefix.
            '';
          }

          {
            assertion =
              lib.all (phaseName: lib.all (item: item.actions != [ ]) cfg.settings.phases.${phaseName})
                [
                  "early"
                  "startup"
                  "late"
                ];

            message = ''
              Each item in boot.loader.sprout.settings.phases must have a non-empty 'actions' list.
            '';
          }

          {
            assertion =
              lib.all
                (
                  phaseName:
                  lib.all (
                    item: lib.all (act: lib.hasAttr act cfg.settings.actions) item.actions
                  ) cfg.settings.phases.${phaseName}
                )
                [
                  "early"
                  "startup"
                  "late"
                ];

            message = ''
              All actions referenced by boot.loader.sprout.settings.phases must exist in boot.loader.sprout.settings.actions.
            '';
          }

          {
            assertion =
              lib.all
                (
                  phaseName:
                  lib.all (
                    item: lib.all (key: !lib.hasPrefix "sprout_extra_file_" key) (lib.attrNames item.values)
                  ) cfg.settings.phases.${phaseName}
                )
                [
                  "early"
                  "startup"
                  "late"
                ];

            message = ''
              boot.loader.sprout.settings.phases.<name>.*.values cannot use reserved 'sprout_extra_file_' prefix.
            '';
          }

          {
            assertion = lib.all (name: builtins.match "[A-Za-z_][A-Za-z0-9_]*" name != null) (
              lib.attrNames cfg.settings.values
            );

            message = ''
              boot.loader.sprout.settings.values attribute names must match [A-Za-z_][A-Za-z0-9_]*.
            '';
          }

          {
            assertion = lib.all (name: !lib.hasPrefix "sprout_extra_file_" name) (
              lib.attrNames cfg.settings.values
            );

            message = ''
              boot.loader.sprout.settings.values cannot use reserved 'sprout_extra_file_' prefix.
            '';
          }
        ];
      };
    };
}
