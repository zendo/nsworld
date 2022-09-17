{
  description = "Hello World";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    # nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.05";
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs-pr.url = "github:NixOS/nixpkgs/pull/190151/merge";
    # nixpkgs-pr.url = "git+file:///home/iab/devs/nixpkgs/?ref=gnome-shell";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay/b50178f76a7868d0aca28278451141269df137fe";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # agenix.url = github:ryantm/agenix;
    # sops-nix.url = github:Mic92/sops-nix;
    # devshell.url = "github:numtide/devshell";
    nur.url = "github:nix-community/NUR";
    musnix.url = "github:musnix/musnix";
    templates.url = "github:NixOS/templates";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    # nixpkgs-pr,
    # nixpkgs-stable,
    # nixpkgs-unstable,
    nixos-hardware,
    home-manager,
    emacs-overlay,
    nur,
    musnix,
    nixos-wsl,
    templates,
    flake-utils,
    ...
  }: let
    mkHost = import ./lib/mkHost.nix inputs;

    overlays = [
      nur.overlay
      emacs-overlay.overlay
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

            ./overlays/v2raya/v2raya.nix
            # {services.v2raya.enable = true;}

            musnix.nixosModules.musnix
            {musnix.enable = true;}

            ({
              config,
              pkgs,
              ...
            }: {
              environment.systemPackages = with pkgs; [
                # nixpkgs-pr.legacyPackages.${system}.gnomeExtensions.pano
              ];
            })
          ];
        };

        svp = mkHost {
          username = "zendo";
          hostname = "svp";
          # hmEnable = false;
          # nixpkgs = inputs.nixpkgs-stable;
          inherit overlays;
          extraModules = [
            ./modules/gnome.nix
            # ./modules/kde.nix
          ];
        };
      };

      #######################################################################
      ## HM Standalone
      #######################################################################
      # nix run nixpkgs#home-manager build switch -- --flake .#$(whoami)
      homeConfigurations = let
        username = "iab";
        system = "x86_64-linux";
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            nur.overlay
            emacs-overlay.overlay
            (import ./overlays)
          ];
        };
      in {
        ${username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          # extraSpecialArgs = {inherit inputs;};
          modules = [
            ./home-manager/cli.nix
            ./home-manager/zsh.nix
            ./home-manager/alias.nix
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
      # nix build .#nixosConfigurations.wsl.config.system.build.installer
      nixosConfigurations.wsl = let
        username = "iab";
        # nixpkgs = inputs.nixpkgs-stable;
      in
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {inherit inputs username;};
          modules = [
            "${inputs.nixos-wsl}/configuration.nix"
            ./modules/nixconfig.nix
            ./hosts/wsl.nix

            {nixpkgs.overlays = overlays;}

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {inherit inputs;};
              home-manager.users.${username} = import ./home-manager;
            }
          ];
        };

      #######################################################################
      ## VM
      #######################################################################
      # nix build .#nixosConfigurations.vmtest.config.system.build.vm
      nixosConfigurations.vmtest = let
        username = "test";
        system = "x86_64-linux";
      in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit inputs username;};
          modules = [
            ./hosts/vmtest.nix
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
      in {
        # nix fmt :Formatter all files in this repo.
        formatter = inputs.nixpkgs.legacyPackages.${system}.alejandra;
        # nix develop .#rust
        devShells = import ./devshells.nix {inherit pkgs;};
        # nix build .#apps or self#apps / nix run self#apps
        packages = pkgs;
      }
    );
}
