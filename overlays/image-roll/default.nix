{
  lib,
  rustPlatform,
  fetchFromGitHub,
  glib,
  pkg-config,
  wrapGAppsHook4,
  desktop-file-utils,
  gtk4,
}:
rustPlatform.buildRustPackage rec {
  pname = "image-roll";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "weclaw1";
    repo = pname;
    rev = version;
    sha256 = "sha256-w1lZQySRWCaOHlD5YCLEy6SaXSQ0eoibwpCYt2IQh8I=";
  };

  cargoSha256 = "sha256-J8bWuYG+qUIaXP5aTBRhswfz6PKPGbzdTc09NYTfcVo=";

  nativeBuildInputs = [glib pkg-config wrapGAppsHook4];

  buildInputs = [gtk4];

  doCheck = false;

  postInstall = ''
    install -Dm444 src/resources/com.github.weclaw1.ImageRoll.desktop -t $out/share/applications/
    install -Dm444 src/resources/com.github.weclaw1.ImageRoll.svg -t $out/share/icons/hicolor/scalable/apps/
    install -Dm444 src/resources/com.github.weclaw1.ImageRoll.metainfo.xml -t $out/share/metainfo/
    install -Dm644 ./src/resources/com.github.weclaw1.ImageRoll.gschema.xml -t $out/share/glib-2.0/schemas/
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta = with lib; {
    description = "Simple and fast GTK image viewer with basic image manipulation tools";
    homepage = "https://github.com/weclaw1/image-roll";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [figsoda];
  };
}
