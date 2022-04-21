{
  lib,
  stdenv,
  fetchFromGitLab,
  glib,
  meson,
  ninja,
  gettext,
  gnome,
}:
stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-night-theme-switcher";
  version = "63";

  src = fetchFromGitLab {
    owner = "rmnvgr";
    repo = "nightthemeswitcher-gnome-shell-extension";
    rev = version;
    sha256 = "sha256-QDg7EflreZaOjD7x6zuEVpyietTe45M0bhXJlZC/YOs=";
  };

  nativeBuildInputs = [meson ninja gettext];
  buildInputs = [glib gnome.gnome-shell];

  passthru = {
    extensionUuid = "nightthemeswitcher@romainvigier.fr";
    extensionPortalSlug = "night-theme-switcher";
  };

  meta = with lib; {
    description = "Automatically change the GTK theme to dark variant when Night Light activates";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [jonafato zendo];
    homepage = "https://gitlab.com/rmnvgr/nightthemeswitcher-gnome-shell-extension/";
  };
}
