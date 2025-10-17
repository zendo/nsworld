{ pkgs, ... }:
let
  chromeEnv = [
    # Force GPU acceleration
    "--ignore-gpu-blocklist"
    "--enable-zero-copy"
    "--wayland-text-input-version=3"
    "--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoDecoder,Vulkan,WebRTCPipeWireCapturer,WaylandWindowDecorations,TouchpadOverscrollHistoryNavigation"
  ];
in
{
  home.packages = with pkgs; [
    (google-chrome.override { commandLineArgs = chromeEnv; })
    # (brave.override { commandLineArgs = chromeEnv; })
    # (vivaldi.override {
    #   proprietaryCodecs = true;
    #   enableWidevine = true; # drm
    # })
    # (opera.override { proprietaryCodecs = true; })
    # microsoft-edge
  ];

  programs.chromium = {
    # enable = true;
    # package = pkgs.chromiumDev;
    commandLineArgs = chromeEnv;
    extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "fihnjjcciajhdojfnbdddfaoknhalnja" # I don't care about cookies
      "jlgkpaicikihijadgifklkbpdajbkhjo" # CrxMouse: Mouse Gestures
      "hmbmmdjlcdediglgfcdkhinjdelkiock" # Font Rendering Enhancer
      "dhdgffkkebhmkfjojejmpbldmpobfkfo" # Tampermonkey
      "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
      "laachonhdpgpkjkppmjebihlklbeekhm" # Simple Proxy Switcher
      "edenohjoklbajppddnaimojnemafnkkg" # markab
      "bpoadfkcbjbfhfodiogcnhhhpibjhbnh" # Immersive Translate
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
    ];
  };
}
