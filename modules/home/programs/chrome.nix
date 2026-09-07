{
  flake.modules.homeManager.chrome =
    { pkgs, ... }:
    let
      # https://wiki.nixos.org/wiki/Chromium
      chromeEnv = [
        "--enable-zero-copy"
        "--enable-features=AcceleratedVideoEncoder"
        "--enable-features=VaapiVideoDecoder,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE"
        # "--enable-features=WaylandWindowDecorations"
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
        # Nixos option
        # extraOpts = {
        #   # ManifestV2 support
        #   "ExtensionManifestV2Availability" = 2;
        # };
        extensions = [
          "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
          "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
          # "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
          "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBlock Origin Lite
          "edibdbjcniadpccecjdfdjjppcpchdlm" # I still don't care about cookies
          "mpiodijhokgodhhofbcjdecpffjipkle" # SingleFile
          "acclmfofilomofphlgfbkhheoakkannc" # Oasis Proxy 2
          "nipdbleimjhfpfdkopbfeagjjkmcfhbj" # Mouse Gesture
          "gkkkcomfmldkigajkmljnbpiajbpbgdg" # TWP - Translate Web Pages
          "ndcooeababalnlpkfedmmbbbgkljhpjf" # ScriptCat
          # "dhdgffkkebhmkfjojejmpbldmpobfkfo" # Tampermonkey
          # "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
          # "hmbmmdjlcdediglgfcdkhinjdelkiock" # Font Rendering Enhancer
        ];
      };
    };
}
