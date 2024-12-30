{ pkgs, ... }:
let
  # https://github.com/yokoffing/Betterfox
  betterfox = pkgs.fetchFromGitHub {
    owner = "yokoffing";
    repo = "Betterfox";
    rev = "133.0";
    hash = "sha256-Uu/a5t74GGvMIJP5tptqbiFiA+x2hw98irPdl8ynGoE=";
  };
in
{
  programs.firefox = {
    enable = true;
    # package = pkgs.firefox-bin;
    languagePacks = [ "zh-CN" ];
    profiles.default = {
      extraConfig = ''
        ${builtins.readFile "${betterfox}/user.js"}
        ${builtins.readFile "${betterfox}/Fastfox.js"}

        // PREF: restore Top Sites on New Tab page
        user_pref("browser.newtabpage.activity-stream.feeds.topsites", true);

        // PREF: restore search engine suggestions
        user_pref("browser.search.suggest.enabled", true);

        // PREF: allow websites to ask you for your location
        user_pref("permissions.default.geo", 0);

        // PREF: allow websites to ask you to receive site notifications
        // user_pref("permissions.default.desktop-notification", 0);
      '';
      settings = {
        "browser.tabs.closeTabByDblclick" = true; # 双击关闭标签
        "browser.tabs.closeWindowWithLastTab" = false; # 关闭最后一个标签不退出界面
        "browser.tabs.selectOwnerOnClose" = false; # 关闭标签后选附近标签而不是原始
        "browser.tabs.loadBookmarksInBackground" = true; # 在后台打开书签栏新建标签页
        "browser.toolbars.bookmarks.visibility" = "always"; # 总是显示书签栏
        "browser.aboutwelcome.enabled" = false; # 关闭欢迎引导界面
        "browser.aboutConfig.showWarning" = false; # 关闭 about:config 打开警告

        "gfx.webrender.all" = true; # 开启GPU极速渲染
        "media.ffmpeg.vaapi.enabled" = true; # enable hw video acceleration
        # https://pandasauce.org/get-fonts-done/
        "gfx.text.subpixel-position.force-enabled" = true;
        "gfx.webrender.quality.force-subpixel-aa-where-possible" = true;
      };
    };
  };

  programs.floorp = {
    # enable = true;
    profiles.default = {
      settings = {
        "browser.tabs.closeTabByDblclick" = true; # 双击关闭标签
        "browser.tabs.closeWindowWithLastTab" = false; # 关闭最后一个标签不退出界面
        "browser.tabs.selectOwnerOnClose" = false; # 关闭标签后选附近标签而不是原始
      };
    };
  };
}
