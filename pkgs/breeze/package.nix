{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  flatpak-extract,
  autoPatchelfHook,
  gtk3,
  webkitgtk_4_1,
  glib-networking,
  libgcc,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "breeze";
  version = "3.0.38";
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/deretame/Breeze/releases/download/v${finalAttrs.version}/breeze-v${finalAttrs.version}.flatpak";
    hash = "sha256-XqirpPhbrSiVruOCA3wrEyZytqMrCj2FAd4KrmKJwl0=";
  };

  nativeBuildInputs = [
    makeWrapper
    flatpak-extract
    autoPatchelfHook
  ];

  buildInputs = [
    gtk3
    webkitgtk_4_1
    glib-networking
    libgcc.lib
  ];

  autoPatchelfIgnoreMissingDeps = [ "libjvm.so" ];

  unpackPhase = ''
    flatpak-extract "$src" --outdir extracted
    cd extracted/files/breeze
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -a . $out/breeze

    install -Dm644 "io.github.windy.breeze.png" \
      "$out/share/icons/hicolor/512x512/apps/io.github.windy.breeze.png"
    install -Dm644 "io.github.windy.breeze.desktop" \
      "$out/share/applications/io.github.windy.breeze.desktop"

    makeWrapper "$out/breeze/breeze" "$out/bin/breeze" \
      --prefix LD_LIBRARY_PATH : "$out/breeze/lib"
  '';

  meta = {
    description = "Comic reader with multi-source support via extensible plugins.";
    homepage = "https://github.com/deretame/Breeze";
    license = lib.licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "breeze";
  };
})
