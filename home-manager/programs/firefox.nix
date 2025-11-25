{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    # package = pkgs.firefox-bin;
    languagePacks = [ "zh-CN" ];

    # Random Profiles Name
    profiles.huohu = {
      isDefault = true;
      # userChrome = ''
      #   @import "${pkgs.firefox-gnome-theme}/userChrome.css";
      # '';
      # userContent = ''
      #   @import "${pkgs.firefox-gnome-theme}/userContent.css";
      # '';
      # and add: ${builtins.readFile "${pkgs.firefox-gnome-theme}/configuration/user.js"}
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
      settings = { };
    };

    # Administrator Group Policy
    policies = {
      Preferences = {
        "browser.tabs.closeTabByDblclick" = true;
        "browser.tabs.closeWindowWithLastTab" = false; # Prevent closing Firefox when closing the last tab
        "browser.tabs.selectOwnerOnClose" = false; # Closing tab and return to the adjacent tab
        "browser.tabs.loadBookmarksInTabs" = true; # Open bookmarks in a new tab
        "browser.tabs.insertAfterCurrent" = true; # Open new tabs next to current
        # "browser.tabs.loadBookmarksInBackground" = true;
        "browser.toolbars.bookmarks.visibility" = "always";
        # "browser.urlbar.openintab" = true;
        # "browser.search.openintab" = true;
        "browser.aboutwelcome.enabled" = false;
        "browser.aboutConfig.showWarning" = false;

        # https://pandasauce.org/get-fonts-done/
        "gfx.text.subpixel-position.force-enabled" = true;
        "gfx.webrender.quality.force-subpixel-aa-where-possible" = true;
      };
      # https://mozilla.github.io/policy-templates/#searchengines--add
      SearchEngines = {
        Add = [
          {
            Name = "GitHub Search";
            URLTemplate = "https://github.com/search?q={searchTerms}";
            IconURL = "https://github.com/fluidicon.png";
            Alias = "gh";
          }
          {
            Name = "Searchix";
            URLTemplate = "https://searchix.ovh/?query={searchTerms}";
            IconURL = "https://searchix.ovh/favicon.ico";
            Alias = "nsa";
          }
          {
            Name = "MyNixOS";
            URLTemplate = "https://www.mynixos.com/search?q={searchTerms}";
            IconURL = "https://mynixos.com/favicon.ico";
            Alias = "mynixos";
          }
          {
            Name = "Nix Packages";
            URLTemplate = "https://search.nixos.org/packages?channel=unstable&type=packages&query={searchTerms}";
            IconURL = "file://${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            Alias = "np";
          }
          {
            Name = "Home Manager Options";
            URLTemplate = "https://home-manager-options.extranix.com/?release=master&query={searchTerms}";
            Alias = "hm";
          }
        ]; # end of Add
      }; # end of SearchEngines
    }; # end of policies
  }; # end of programs.firefox
}
