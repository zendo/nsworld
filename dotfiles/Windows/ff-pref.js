/** MY PREFERENCES ***/

// Prompts
user_pref("browser.aboutConfig.showWarning", false);
user_pref("signon.rememberSignons", false); // Don't ask to save passwords
user_pref("browser.translations.automaticallyPopup", false); // Don't ask to translate

// Bookmarks
user_pref("browser.toolbars.bookmarks.visibility", "always");

// Tabs
user_pref("sidebar.verticalTabs", true);
user_pref("browser.tabs.closeTabByDblclick", true);
user_pref("browser.tabs.closeWindowWithLastTab", false); // Prevent closing Firefox when closing the last tab
user_pref("browser.tabs.selectOwnerOnClose", false); // Closing tab and return to the adjacent tab
user_pref("browser.tabs.insertAfterCurrent", true); // Open new tabs next to current
user_pref("browser.tabs.loadBookmarksInTabs", true); // Open bookmarks in a new tab
// user_pref("browser.tabs.loadBookmarksInBackground", true);
// user_pref("browser.urlbar.openintab", true); // open in a new tab
// user_pref("browser.search.openintab", true); // open in a new tab


// Fonts: https://github.com/yokoffing/Betterfox/wiki/Common-Overrides#font-improvement
// PREF: improve font rendering by using DirectWrite everywhere like Chrome [WINDOWS]
user_pref("gfx.font_rendering.cleartype_params.rendering_mode", 5);
user_pref("gfx.font_rendering.cleartype_params.cleartype_level", 100);
user_pref("gfx.font_rendering.directwrite.use_gdi_table_loading", false);
