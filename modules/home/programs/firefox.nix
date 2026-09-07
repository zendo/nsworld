{
  flake.modules.homeManager.firefox =
    { pkgs, ... }:
    {
      programs.firefox = {
        enable = true;
        # package = pkgs.firefox-bin;
        languagePacks = [ "zh-CN" ];

        # Random Profiles Name
        profiles.huohu = {
          isDefault = true;
          settings = {
            # Languages
            "intl.accept_languages" = "zh-CN, en";
            "intl.locale.requested" = "zh-CN";

            # Prompts
            "browser.aboutwelcome.enabled" = false;
            "browser.aboutConfig.showWarning" = false;
            "signon.rememberSignons" = false; # Don't ask to save passwords
            "browser.translations.automaticallyPopup" = false; # Don't ask to translate

            # Bookmarks
            "browser.toolbars.bookmarks.visibility" = "always";

            # Tabs
            "sidebar.verticalTabs" = true;
            "browser.tabs.closeTabByDblclick" = true;
            "browser.tabs.closeWindowWithLastTab" = false; # Prevent closing Firefox when closing the last tab
            "browser.tabs.selectOwnerOnClose" = false; # Closing tab and return to the adjacent tab
            "browser.tabs.insertAfterCurrent" = true; # Open new tabs next to current
            "browser.tabs.loadBookmarksInTabs" = true; # Open bookmarks in a new tab

            # Fonts: https://pandasauce.org/get-fonts-done/
            "gfx.text.subpixel-position.force-enabled" = true;
            "gfx.webrender.quality.force-subpixel-aa-where-possible" = true;
          };
          extraConfig = ''
            ${builtins.readFile "${pkgs.betterfox}/user.js"}

            // PREF: restore AI features
            // user_pref("browser.ai.control.default", "available")

            // PREF: restore Top Sites on New Tab page
            user_pref("browser.newtabpage.activity-stream.feeds.topsites", true);

            // PREF: restore live search suggestions
            user_pref("browser.search.suggest.enabled", true);

            // PREF: allow websites to ask you for your location
            // 0:Ask 1:Allow 2:Block(default)
            user_pref("permissions.default.geo", 0);

            // PREF: allow websites to ask you to receive site notifications
            // user_pref("permissions.default.desktop-notification", 0);
          '';
        };

        # Administrator Group Policy
        policies = {
          DisableTelemetry = true;
          DontCheckDefaultBrowser = true;
          # Preferences = { };
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
                Name = "nixsearch";
                URLTemplate = "https://nixsearch.thekoppe.com/?q={searchTerms}";
                IconURL = "https://nixsearch.thekoppe.com/favicon.ico";
                Alias = "nsa";
              }
            ]; # Add
          }; # SearchEngines
        }; # policies

      }; # programs.firefox
    };
}
