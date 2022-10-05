{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  icu,
  boost,
  libiconv,
  opencc,
  capnproto,
}:
stdenv.mkDerivation rec {
  pname = "librime-charcode";
  version = "2022-02-04";

  src = fetchFromGitHub {
    owner = "rime";
    repo = pname;
    rev = "e20e3993c42fc86c8209e808ed0762aea24261e0";
    hash = "sha256-MHDirPoApNfXpc01M+Xq7p+MiS+pJaxuDo3aROc80e0=";
  };

  nativeBuildInputs = [
    cmake
    # ninja
    pkg-config
    capnproto
  ];

  buildInputs = [
    icu
    boost
    libiconv
    opencc
  ];

  # postPatch = ''
  #   substituteInPlace wifi-qr --replace "/usr/share" "$out/share"
  #   chmod +x wifi-qr
  #   patchShebangs wifi-qr
  # '';

  # installPhase = ''
  #   install -Dm755 wifi-qr "$out/bin/wifi-qr"
  #   install -Dm644 wifi-qr.svg "$out/share/icons/hicolor/scalable/apps/wifi-qr.svg"
  #   install -Dm644 wifi-qr.desktop "$out/share/applications/wifi-qr.desktop"
  #   # install -Dm644 LICENSE "$out/share/licenses/wifi-qr/LICENSE"
  #   install -Dm644 LICENSE "$out/share/doc/wifi-qr/copyright"

  #   installManPage wifi-qr.1

  #   wrapProgram "$out/bin/wifi-qr" \
  #     --prefix PATH : "${lib.makeBinPath [zbar gnome.zenity]}"
  # '';

  meta = with lib; {
    description = "Create and scan Wifi QR code";
    homepage = "https://github.com/kokoye2007/wifi-qr";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [zendo];
  };
}
