{
  flake.modules.nixos.nixpkgs =
    { inputs, lib, ... }:
    {
      nixpkgs = {
        overlays = builtins.attrValues inputs.self.overlays;

        config = {
          # allowUnfree = true;
          # allowBroken = true;
          # allowInsecure = true;
          # allowUnsupportedSystem = true;
          android_sdk.accept_license = true;
          allowUnfreePredicate =
            pkg:
            builtins.elem (lib.getName pkg) [
              "unrar"
              "steam"
              "vscode"
              "spotify"
              "qqmusic"
              "google-chrome"
              "microsoft-edge"
              "vivaldi"
              "widevine-cdm"
              "steam-unwrapped"
              "balatro"
              "memtest86-efi"
              "android-sdk-cmdline-tools"
            ];
        };
      };
    };
}
