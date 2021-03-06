{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  cmake,
  pkg-config,
  glib,
  gtk4,
  libxml2,
  libadwaita,
  rustPlatform,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
}:
stdenv.mkDerivation rec {
  pname = "app-icon-preview";
  version = "unstable-2022-05-30";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World/design";
    repo = pname;
    rev = "21347dd43bcedf1bc612d3e9e188139a9498dc19";
    sha256 = "sha256-zK3xP47wJxHq/hYghCMRlCDPMQyi3uI0jmUpVd37Y/w=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-ljLJCHeNueIPMZ+EVLZWbUHQqI/GXrRM0lxANWJNA04=";
  };

  nativeBuildInputs =
    [
      glib
      meson
      ninja
      cmake
      pkg-config
      wrapGAppsHook4
      appstream-glib
      desktop-file-utils
    ]
    ++ (with rustPlatform; [
      rust.cargo
      rust.rustc
      cargoSetupHook
    ]);

  buildInputs = [
    glib
    gtk4
    libxml2
    libadwaita
  ];

  postPatch = ''
    patchShebangs build-aux
  '';

  meta = with lib; {
    description = "Tool for designing applications icons";
    homepage = "https://gitlab.gnome.org/World/design/app-icon-preview";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [zendo];
  };
}
