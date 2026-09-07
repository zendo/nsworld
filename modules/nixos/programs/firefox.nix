{
  flake.modules.nixos.firefox =
    { pkgs, ... }:
    {
      programs.firefox = {
        enable = true;
        # package = pkgs.firefox-bin;
        languagePacks = [ "zh-CN" ];

        preferencesStatus = "default";
        preferences = {
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

        policies = {
          DisableTelemetry = true;
          DontCheckDefaultBrowser = true;
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
            ];
          }; # SearchEngines
        }; # policies
      };
    };
}
