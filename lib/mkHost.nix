/*
{ system, pkgs, home-manager, lib, user, ... }:
with builtins;
{
  mkHost = { name, NICs, initrdMods, kernelMods, kernelParams, kernelPackage,
    systemConfig, cpuCores, users, wifi ? [],
    gpuTempSensor ? null, cpuTempSensor ? null
  }:
  let
    networkCfg = listToAttrs (map (n: {
      name = "${n}"; value = { useDHCP = true; };
    }) NICs);

    userCfg = {
      inherit name NICs systemConfig cpuCores gpuTempSensor cpuTempSensor;
    };

    sys_users = (map (u: user.mkSystemUser u) users);
  in lib.nixosSystem {
    inherit system;

    modules = [
      {
        imports = [ ../modules/system ] ++ sys_users;

        jd = systemConfig;

        environment.etc = {
          "hmsystemdata.json".text = toJSON userCfg;
        };

        networking.hostName = "${name}";
        networking.interfaces = networkCfg;
        networking.wireless.interfaces = wifi;

        networking.networkmanager.enable = true;
        networking.useDHCP = false;

        boot.initrd.availableKernelModules = initrdMods;
        boot.kernelModules = kernelMods;
        boot.kernelParams = kernelParams;
        boot.kernelPackages = kernelPackage;

        nixpkgs.pkgs = pkgs;
        nix.maxJobs = lib.mkDefault cpuCores;

        system.stateVersion = "21.05";
      }
    ];
  };
}

# https://github.com/fersilva16/nix-config
{inputs}: let
  inherit (inputs) nixpkgs home-manager;
in
  {
    hostname,
    system ? "x86_64-linux",
    username ? "unknow",
  }:
    nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit inputs system hostname username;
      };

      modules = [
        home-manager.nixosModule

        (../hosts + "/${hostname}/hardware-configuration.nix")

        {
          networking.hostName = hostname;

          nixpkgs = {
            config.allowUnfree = true;
            # config.allowBroken = true;
            # config.allowUnsupportedSystem = true;
            overlays = with inputs; [
              nur.overlay
              emacs-overlay.overlay
              (import ../overlays)
              (final: prev: {
                local = local.legacyPackages.${prev.system};
              })
            ];
          };

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
          };
        }
      ];
      # ++ nixpkgs.lib.forEach users (user: ../users + "/${user}.nix");
    }

#######################################################
#######################################################
#######################################################
#######################################################
      nixosSystem =
        { system ? "x86_64-linux"
        , configuration ? { }
        , modules ? [ ]
        , overlays ? [ ]
        , extraModules ? [ ]
        , specialArgs ? { }
        , ...
        }:
        let
          pkgs = (importPkgs nixos overlays system);
        in
        lib.nixosSystem {
          inherit system;
          modules = [
            configuration
            {
              nixpkgs = { inherit pkgs; };
            }
          ] ++ modules ++ extraModules;
          specialArgs = {
            inherit
              (inputs)
              unstable
              nixos
              home
              nixos-wsl;
            inherit
              username;
          } // specialArgs;
#######################################################
#######################################################
#######################################################

# https://github.com/rafaelrc7/dotfiles
inputs: let
  inherit (inputs.nixpkgs.lib) nixosSystem;
in rec {

  mkPkgs = { nixpkgs ? inputs.nixpkgs, overlays ? [], system }:
    import nixpkgs {
      inherit system;
      config.allowUnfree = true;

      overlays = overlays ++ [
        inputs.nur.overlay
        #(import ../overlay { inherit inputs sytem; })
        (final: prev: {
          nixpkgs-stable = inputs.nixpkgs-stable.legacyPackages."${system}";
          nixpkgs-unstable = inputs.nixpkgs-unstable.legacyPackages."${system}";
          nixpkgs-master = inputs.nixpkgs-master.legacyPackages."${system}";
        })
        inputs.nixgl.overlay
      ];
    };

  mkUser = { name, extraGroups ? [], sshKeys ? [], ... }: {
    inherit name;
    value = {
      isNormalUser = true;
      createHome = true;
      group = "${name}";
      openssh.authorizedKeys.keys = sshKeys;
      inherit extraGroups;
    };
  };

  mkUserGroup = config: { name, ... }: {
    inherit name;
    value = {
      gid = config.users.users."${name}".uid;
    };
  };

  mkUsers = with builtins; users: { config, ... }: {
    users = {
      users = listToAttrs (map mkUser users);
      groups = listToAttrs (map (mkUserGroup config) users);
    };
  };

  mkHMUser = with builtins; { name, homeModules ? [], ... }: {
    inherit name;
    value = { imports = [(../users + "/${name}")] ++ homeModules; };
  };

  mkHMUsers = with builtins; users: listToAttrs (map mkHMUser users);

  mkHost = { hostName,
             system ? "x86_64-linux",
             users ? [],
             nixosModules ? [],
             nixpkgs ? inputs.nixpkgs }:
  let
    pkgs = mkPkgs { inherit nixpkgs system; };
  in nixosSystem {
    inherit system;

    specialArgs = {
      inherit pkgs inputs system nixpkgs;
      inherit (inputs) home-manager nur;
    };

    modules = nixosModules ++ [
      (../hosts + "/${hostName}")
      (mkUsers users)
      inputs.home-manager.nixosModules.home-manager {
        home-manager = {
          useUserPackages = true;
          extraSpecialArgs = { inherit inputs pkgs nixpkgs; };
          users = mkHMUsers users;
        };
      }
    ];
  };

  mkHome = { username,
             system ? "x86_64-linux",
             homeModules ? [],
             overlays ? [],
             nixpkgs ? inputs.nixpkgs }:
  let
    pkgs = mkPkgs { inherit nixpkgs system overlays; };
    homeDirectory = "/home/${username}";
  in inputs.home-manager.lib.homeManagerConfiguration {
    inherit system username homeDirectory pkgs;
    stateVersion = "22.05";
    extraSpecialArgs = { inherit inputs pkgs nixpkgs system username; };
    configuration.imports = homeModules ++ [(../users + "/${username}")];
  };
}
*/
