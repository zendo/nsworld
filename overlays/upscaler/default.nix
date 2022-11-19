{ lib
, stdenv
, fetchFromGitLab
, python3
, meson
, ninja
, pkg-config
, gtk4
, glib
, libadwaita
, librsvg
, blueprint-compiler
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

python3.pkgs.buildPythonApplication rec {
  pname = "upscaler";
  version = "1.0.0";
  format = "other";

  src = fetchFromGitLab {
    owner = "TheEvilSkeleton";
    repo = "Upscaler";
    rev = version;
    hash = "sha256-3Wj5HckehmJ8dJf11EUHQLEWhh3IUo89Gybq4n3QzDg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    blueprint-compiler
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    librsvg
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
  ];

  meta = with lib; {
    description = "Upscale and enhance images";
    homepage = "https://gitlab.com/TheEvilSkeleton/Upscaler";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
