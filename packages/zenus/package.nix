{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook3,
  autoPatchelfHook,
  udev,
  webkitgtk_4_1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zenus";
  version = "0.2.6";

  src = fetchurl {
    url = "https://github.com/skorotkiewicz/zenus/releases/download/${finalAttrs.version}/zenus_${finalAttrs.version}_amd64.deb";
    hash = "sha256-OkjMNB0TDm4V+AuinEBrHFn/q2GFokE6PsCb1IGGbEY=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook3
    autoPatchelfHook
  ];

  buildInputs = [
    webkitgtk_4_1
    (lib.getLib stdenv.cc.cc)
  ];

  runtimeDependencies = [ (lib.getLib udev) ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r usr/* $out
  '';

  meta = {
    description = "Beautiful note-taking app";
    homepage = "https://github.com/skorotkiewicz/zenus";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "zenus";
  };
})
