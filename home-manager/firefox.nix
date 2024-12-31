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
        "browser.tabs.closeTabByDblclick" = true;
        "browser.tabs.closeWindowWithLastTab" = false; # Prevent closing Firefox when closing the last tab
        "browser.tabs.selectOwnerOnClose" = false; # Closing tab and return to the adjacent tab
        "browser.tabs.loadBookmarksInBackground" = true;
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.aboutwelcome.enabled" = false;
        "browser.aboutConfig.showWarning" = false;

        "gfx.webrender.all" = true; # enable GPU render
        "media.ffmpeg.vaapi.enabled" = true; # enable hw video acceleration
        # https://pandasauce.org/get-fonts-done/
        "gfx.text.subpixel-position.force-enabled" = true;
        "gfx.webrender.quality.force-subpixel-aa-where-possible" = true;
      };
    };
  };
}
