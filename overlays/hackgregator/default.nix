{ lib
, stdenv
, rustPlatform
, fetchFromGitLab
, meson
, ninja
, pkg-config
, openssl
, libsoup_3
, webkitgtk_5_0
, glib
, gtk4
, libadwaita
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "hackgregator";
  version = "0.4.1";

  src = fetchFromGitLab {
    owner = "gunibert";
    repo = pname;
    rev = "${version}";
    hash = "sha256-7yUFUG/9npRkoMB/e1Ba87ZbxUYQJcOhYVg5+E78Zs0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-c5yWUDz2o1+V5kcznLWIgu/rFVRw1zHpMjirfdmSJ0Y=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config

    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ] ++ (with rustPlatform; [
    rust.cargo
    rust.rustc
    cargoSetupHook
  ]);

  buildInputs = [
    openssl
    glib
    gtk4
    libsoup_3
    libadwaita
    webkitgtk_5_0
  ];

  meta = with lib; {
    description = "This application is a comfortable reader application for news.ycombinator.com";
    homepage = "https://gitlab.com/gunibert/hackgregator";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
