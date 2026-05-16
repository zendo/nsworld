{ config, ... }:
{
  flake.modules.nixos.nixpkgs =
    { lib, ... }:
    {
      nixpkgs = {
        overlays = builtins.attrValues config.flake.overlays;

        config = {
          # allowUnfree = true;
          # allowBroken = true;
          # allowInsecure = true;
          # allowUnsupportedSystem = true;
          android_sdk.accept_license = true;
          allowUnfreePredicate =
            pkg:
            builtins.elem (lib.getName pkg) [
              "replace"
              "unrar"
              "spotify"
              "qqmusic"
              "vivaldi"
              "google-chrome"
              "microsoft-edge"
              "widevine-cdm"
              "steam"
              "steam-unwrapped"
              "balatro"
              "memtest86-efi"
              "android-sdk-cmdline-tools"
              "vscode"
              "vscode-extension-ms-vscode-cpptools"
              "vscode-extension-ms-vscode-remote-remote-ssh"
            ];
        };
      };
    };
}
