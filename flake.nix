{
  description = "Hello World";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    # nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.05";
    # nixpkgs.url = "github:NixOS/nixpkgs/pull/213619/merge";
    # nixpkgs.url = "git+file:///home/iab/devs/nixpkgs/?ref=gnomeExtensions";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay/a68a3753466c045db326a7f7b9a25b35a2935225";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # hyprland = {
    #   url = "github:hyprwm/Hyprland";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # agenix.url = github:ryantm/agenix;
    # sops-nix.url = github:Mic92/sops-nix;
    # nur.url = "github:nix-community/NUR";
    musnix.url = "github:musnix/musnix";
    templates.url = "github:NixOS/templates";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # dream2nix.url = "github:nix-community/dream2nix";
    # dream2nix.inputs.nixpkgs.follows = "nixpkgs";

    # nix-npm-buildpackage.url = "github:serokell/nix-npm-buildpackage";
    # nix-npm-buildpackage.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    # nixpkgs-stable,
    home-manager,
    nixos-wsl,
    flake-utils,
    ...
  }: let
    mkHost = import ./lib/mkHost.nix inputs;

    overlays = [
      # inputs.nur.overlay
      inputs.nix-alien.overlay
      inputs.emacs-overlay.overlay
      (import ./overlays)
      # (final: prev: {
      #   pr = nixpkgs-pr.legacyPackages.${prev.system};
      # })
    ];
  in
    {
      nixosConfigurations = {
        yoga = mkHost {
          username = "iab";
          hostname = "yoga";
          inherit overlays;
          extraModules = [
            ./modules/gnome.nix
            # ./modules/kde.nix
            # ./modules/wm-sway.nix
            # ./modules/wm-hyprland.nix

            ({
              config,
              pkgs,
              ...
            }: {
              # disabledModules = ["config/swap.nix"];
              # imports = [
              #   "${inputs.nixpkgs-pr}/nixos/modules/config/swap.nix"
              # ];
              environment.systemPackages = with pkgs; [
                # nixpkgs-pr.legacyPackages.${system}.gnomeExtensions.pano
              ];
            })
          ];
        };

        # nixos-rebuild --target-host zendo@192.168.2.197 --use-remote-sudo --flake .#svp switch
        svp = mkHost {
          username = "zendo";
          hostname = "svp";
          # hmEnable = false;
          # nixpkgs = inputs.nixpkgs-stable;
          inherit overlays;
          extraModules = [
            ./modules/gnome.nix
            # ./modules/kde.nix
            # ./modules/wm-sway.nix
          ];
        };

        # nixos-rebuild build-vm --flake .#vmtest
        vmtest = mkHost {
          username = "test";
          hostname = "vmtest";
          # hmEnable = false;
          virtEnable = false;
          inherit overlays;
          # nixpkgs = inputs.nixpkgs-pr;
        };

        livecd = mkHost {
          username = "livecd";
          hostname = "livecd";
          virtEnable = false;
          inherit overlays;
        };
      };

      # or: nixos-generate -f iso -c ~/nsworld/hosts/livecd/bare-iso.nix
      livecd-iso = self.nixosConfigurations.livecd.config.system.build.isoImage;

      # for repl
      lib = nixpkgs.lib;

      #######################################################################
      ## HM Standalone
      #######################################################################
      # nix run nixpkgs#home-manager build switch -- --flake .#$(whoami)
      homeConfigurations = let
        username = "iab";
        system = "x86_64-linux";
        pkgs = import nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        };
      in {
        ${username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          # extraSpecialArgs = {inherit inputs;};
          modules = [
            ./home-manager/alias.nix
            ./home-manager/cli.nix
            ./home-manager/git.nix
            ./home-manager/zsh.nix
            ./home-manager/tmux.nix
            ./home-manager/xdg.nix
            ./home-manager/non-nixos.nix
            {
              home.stateVersion = "22.05";
              home.username = "${username}";
              home.homeDirectory = "/home/${username}";
            }
          ];
        };
      };

      #######################################################################
      ## WSL
      #######################################################################
      wsl-installer = self.nixosConfigurations.wsl.config.system.build.installer;

      nixosConfigurations.wsl = let
        username = "iab";
        # nixpkgs = inputs.nixpkgs-stable;
      in
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {inherit inputs username;};
          modules = [
            ./hosts/wsl
            ./modules/nixconfig.nix
            ./modules/fonts.nix

            nixos-wsl.nixosModules.wsl
            {
              nixpkgs.overlays = overlays;
              nixpkgs.config.allowUnfree = true;
            }

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {inherit inputs;};
              home-manager.users.${username} = import ./home-manager;
            }
          ];
        };
    }
    // flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = import nixpkgs {
          inherit system overlays;
          allowUnfree = true;
          # allowBroken = true;
          # allowUnsupportedSystem = true;
        };
      in rec {
        # nix build .#apps or self#apps / nix run self#apps
        packages = pkgs;

        # nix fmt :Formatter all files in this repo.
        formatter = packages.alejandra;

        # nix develop .#rust
        devShells = import ./devshells.nix {inherit pkgs;};
      }
    );

  # auto-fetch deps when `nix run/shell/develop`
  nixConfig = {
    bash-prompt = "[nix]λ ";
    # substituters = ["https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"];
    # extra-substituters = ["https://nix-gaming.cachix.org"];
    # extra-trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
  };
}
