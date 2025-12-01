{ pkgs, ... }:
let
  # https://wiki.nixos.org/wiki/Chromium
  chromeEnv = [
    # Force GPU acceleration
    "--ignore-gpu-blocklist"
    "--enable-zero-copy"
    "--enable-features=AcceleratedVideoEncoder,VaapiOnNvidiaGPUs,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE"
    "--enable-features=VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport"
    "--enable-features=UseMultiPlaneFormatForHardwareVideo"
    # wayland supports
    "--wayland-text-input-version=3"
    "--enable-features=WaylandWindowDecorations,TouchpadOverscrollHistoryNavigation"
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
    # Enabling DRM
    package = pkgs.chromium.override { enableWideVine = true; };
    commandLineArgs = chromeEnv;
    # extraOpts = {
    #   # ManifestV2 support
    #   "ExtensionManifestV2Availability" = 2;
    # };
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
