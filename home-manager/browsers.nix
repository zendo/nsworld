{ pkgs, ... }:
let
  chromeEnv = [
    # Force GPU accleration
    "--ignore-gpu-blocklist"
    "--enable-zero-copy"
    "--gtk-version=4" # broken! 主题改经典 fix
    # https://bugs.chromium.org/p/chromium/issues/detail?id=1356014
    "--disable-features=WaylandFractionalScaleV1"
    "--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoDecoder,Vulkan,WebRTCPipeWireCapturer,WaylandWindowDecorations,TouchpadOverscrollHistoryNavigation"
  ];
in
{
  home.packages = with pkgs; [
    (google-chrome.override { commandLineArgs = chromeEnv; })
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
      "hbhaimhpaplfkjfncbkdnadppobbopbi" # SimpleProxy
      "mjidkpedjlfnanainpdfnedkdlacidla" # CLEAN crxMouse Gestures
      "hmbmmdjlcdediglgfcdkhinjdelkiock" # Font Rendering Enhancer
      "aapbdbdomjkkjkaonfhkkikfgjllcleb" # Google Translate
      "jinjaccalgkegednnccohejagnlnfdag" # Violentmonkey
      "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
    ];
  };

  programs.firefox = {
    enable = true;
    # package = pkgs.firefox-bin;
    languagePacks = [ "zh-CN" ];
    profiles.default = {
      settings = {
        "browser.tabs.closeTabByDblclick" = true; # 双击关闭标签
        "browser.tabs.selectOwnerOnClose" = false; # 关闭标签后选附近标签而不是原始
        "browser.tabs.closeWindowWithLastTab" = false; # 关闭最后一个标签不退出界面
        "browser.tabs.firefox-view" = false; # disable Firefox View button on tab
        "browser.toolbars.bookmarks.visibility" = "always"; # Always show bookmarks
        "browser.aboutwelcome.enabled" = false;
        "browser.aboutConfig.showWarning" = false; # Dont show warning when accessing about:config
        "browser.quitShortcut.disabled" = true; # disable annoyinh Ctrl+Q shortcut
        "media.eme.enabled" = true; # DRM

        "gfx.webrender.all" = true; # 开启极速渲染
        "media.ffmpeg.vaapi.enabled" = true; # enable hw video acceleration, if supported
        # https://pandasauce.org/get-fonts-done/
        # "gfx.text.subpixel-position.force-enabled" = true;
        # "gfx.webrender.quality.force-subpixel-aa-where-possible" = true;

        # Enable some helpful features in urlbar
        "browser.urlbar.suggest.calculator" = true;
        "browser.urlbar.unitConversion.enabled" = true;
      };
    };
  };
}
