{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    # package = pkgs.firefox-bin;
    languagePacks = [ "zh-CN" ];
    profiles.default = {
      extraConfig = ''
        ${builtins.readFile "${pkgs.betterfox}/user.js"}

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

        # https://pandasauce.org/get-fonts-done/
        "gfx.text.subpixel-position.force-enabled" = true;
        "gfx.webrender.quality.force-subpixel-aa-where-possible" = true;
      };
      search.enable = false;
      search.engines = {
        google.metaData.alias = "g";
        GitHub = {
          urls = [ { template = "https://github.com/search?q={searchTerms}"; } ];
          icon = "https://github.com/fluidicon.png";
          updateInterval = 24 * 60 * 60 * 1000; # every day
          definedAliases = [ "git" ];
        };
        Searchix = {
          urls = [ { template = "https://searchix.ovh/?query={searchTerms}"; } ];
          definedAliases = [
            "nse"
            "searchix"
          ];
        };
        MyNixOS = {
          urls = [ { template = "https://www.mynixos.com/search?q={searchTerms}"; } ];
          icon = "https://mynixos.com/favicon.ico";
          updateInterval = 24 * 60 * 60 * 1000; # every day
          definedAliases = [
            "mynixos"
          ];
        };
        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "nix" ];
        };
        "Home Manager Options" = {
          urls = [
            {
              template = "https://home-manager-options.extranix.com/";
              params = [
                {
                  name = "release";
                  value = "master";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "hm" ];
        };
      };
    };
  };
}
