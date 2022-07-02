# wip
# pkgs/applications/misc/authenticator/
{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  cmake,
  clang,
  libclang,
  python3,
  rustPlatform,
  zbar,
  pipewire,
  glib,
  gtk4,
  gst_all_1,
  libadwaita,
  sqlite,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
}:
stdenv.mkDerivation rec {
  pname = "decoder";
  version = "0.3.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "decoder";
    rev = "${version}";
    sha256 = "sha256-WJIOaYSesvLmOzF1Q6o6aLr4KJanXVaNa+r+2LlpKHQ=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-WJ3XjwT399JnjexqRkhKhsQEKkBR4VGFTx3sdfuVLpo=";
  };

  nativeBuildInputs =
    [
      meson
      ninja
      pkg-config
      cmake
      # clang
      # libclang
      python3
      pipewire
      wrapGAppsHook4
      appstream-glib
      desktop-file-utils
    ]
    ++ (with rustPlatform; [
      rust.cargo
      rust.rustc
      cargoSetupHook
    ]);

  buildInputs =
    [
      glib
      gtk4
      libadwaita
      zbar
      # sqlite
    ]
    ++ (with gst_all_1; [
      gstreamer
      gst-plugins-base
      gst-plugins-bad
    ]);

  # LIBCLANG_PATH = "${libclang.lib}/lib";

  # libadwaita 1.2 ???
  patchPhase = ''
    sed -i 's/2\.alpha/0\.0/' meson.build
  '';

  meta = with lib; {
    description = "Scan and Generate QR Codes";
    homepage = "https://apps.gnome.org/en/app/com.belmoussaoui.Decoder/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [zendo];
    platforms = platforms.linux;
  };
}
