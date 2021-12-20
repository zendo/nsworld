{
  description = "Yoga14s NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nur = {
    #   url = "github:nix-community/NUR";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # nixos-cn = {
    #   url = "github:nixos-cn/flakes";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # flake-utils.url = "github:numtide/flake-utils";

    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };


  outputs =
    { self
    , nixpkgs
    , home-manager
    , emacs-overlay
    , ...
    }@inputs:{

      nixosConfigurations = {
        "nix" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./modules/hardware-configuration.nix
            ./modules/amd.nix
            # ./modules/intel.nix
            # ./modules/kde.nix
            ./modules/gnome.nix
            ./modules/iab.nix
            ./configuration.nix

            {
              nixpkgs.overlays = [ emacs-overlay.overlay ];
              nixpkgs.config = {
                allowUnfree = true;
                allowBroken = true;
                allowUnsupportedSystem = true;
              };
            }


            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.iab = import ./home.nix;
            }
          ];
        };

      # "nix2" = nixpkgs.lib.nixosSystem {
      #   system = "x86_64-linux";
      #   modules = [
      #     ./configuration2.nix
      #   ];
      # };

      # };
    };
};
}
