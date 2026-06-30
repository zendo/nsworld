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
              "claude-code"
              "amp-cli"
              "unrar"
              "spotify"
              "qqmusic"
              "vivaldi"
              "google-chrome"
              "microsoft-edge"
              "widevine-cdm"
              "keyguard"
              "steam"
              "steam-unwrapped"
              "balatro"
              "pvzge"
              "pvz_logo.webp"
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
