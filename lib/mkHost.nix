# https://github.com/fersilva16/nix-config
inputs: let
   inherit (inputs) self nixpkgs home-manager;
 in
   {
     hostname,
     username,
     system ? "x86_64-linux",
     extra-modules ? [],
   }:
     nixpkgs.lib.nixosSystem {
       system = system;
       specialArgs = {inherit inputs hostname username;};
       modules =
         extra-modules
         ++ [
           ../modules/base.nix
           ../modules/user.nix
           ../modules/network.nix
           ../modules/nixconfig.nix
           ../modules/sound.nix
           ../modules/fonts.nix
           ../modules/virtual.nix
           ../hosts/${hostname}
           {networking.hostName = "${hostname}";}

           {
             nixpkgs.overlays = [
               inputs.nur.overlay
               inputs.emacs-overlay.overlay
               (import ../overlays)
               # (final: prev: {
               #   local = local.legacyPackages.${prev.system};
               # })
             ];
           }

           home-manager.nixosModules.home-manager
           {
             home-manager.useGlobalPkgs = true;
             home-manager.useUserPackages = true;
             home-manager.extraSpecialArgs = {inherit self inputs hostname;};
             home-manager.users.${username} = import ../home-manager;
           }
         ];
     }
