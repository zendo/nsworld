{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook,
  autoPatchelfHook,
  udev,
  libgbm,
  nss,
  pipewire,
  webkitgtk_4_1,
  libsoup_3,
  libayatana-appindicator,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "note-gen";
  version = "0.21.0";

  src = fetchurl {
    url = "https://github.com/codexu/note-gen/releases/download/note-gen-v${finalAttrs.version}/NoteGen_${finalAttrs.version}_amd64.deb";
    hash = "sha256-BLOME2khYNdFFDcfU1BZOqS/Rmw19Iv/FYc+ONkYHIk=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook
    autoPatchelfHook
  ];

  buildInputs = [
    libgbm
    nss
    pipewire
    webkitgtk_4_1
    libsoup_3
    (lib.getLib stdenv.cc.cc)
  ];

  runtimeDependencies = [
    libayatana-appindicator
    (lib.getLib udev)
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r usr/share $out
    install usr/bin/note-gen $out/bin
  '';

  meta = {
    description = "Markdown AI note-taking software";
    homepage = "https://notegen.top";
    downloadPage = "https://github.com/codexu/note-gen";
    mainProgram = "note-gen";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.gpl3;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
  };
})
