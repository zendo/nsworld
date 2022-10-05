{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  zbar,
  gnome,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "wifi-qr";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "kokoye2007";
    repo = pname;
    rev = "${version}";
    hash = "sha256-4cegDpF//6GrExUR+1xPz+idMPjiX/54wP89LRHFZyk=";
  };

  nativeBuildInputs = [makeWrapper installShellFiles];

  postPatch = ''
    substituteInPlace wifi-qr --replace "/usr/share" "$out/share"
    chmod +x wifi-qr
    patchShebangs wifi-qr
  '';

  installPhase = ''
    install -Dm755 wifi-qr "$out/bin/wifi-qr"
    install -Dm644 wifi-qr.svg "$out/share/icons/hicolor/scalable/apps/wifi-qr.svg"
    install -Dm644 wifi-qr.desktop "$out/share/applications/wifi-qr.desktop"
    # install -Dm644 LICENSE "$out/share/licenses/wifi-qr/LICENSE"
    install -Dm644 LICENSE "$out/share/doc/wifi-qr/copyright"

    installManPage wifi-qr.1

    wrapProgram "$out/bin/wifi-qr" \
      --prefix PATH : "${lib.makeBinPath [zbar gnome.zenity]}"
  '';

  meta = with lib; {
    description = "Create and scan Wifi QR code";
    homepage = "https://github.com/kokoye2007/wifi-qr";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [zendo];
  };
}
