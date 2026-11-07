{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook3,
  autoPatchelfHook,
  webkitgtk_4_1,
  glib-networking,
  udev,
  libayatana-appindicator,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "agent-one";
  version = "1.1.3";

  src = fetchurl {
    url = "https://github.com/The-Best-Codes/agent-one/releases/download/agent-one-v${finalAttrs.version}/AgentOne_${finalAttrs.version}_amd64.deb";
    sha256 = "sha256-HsZUO7in7arMh4goQN5dEk0N1B6y1LdhJuPPIHmAcRk=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook3
    autoPatchelfHook
  ];

  buildInputs = [
    webkitgtk_4_1
    glib-networking
    (lib.getLib stdenv.cc.cc)
  ];

  runtimeDependencies = [
    (lib.getLib udev)
    libayatana-appindicator
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r usr/* $out
  '';

  meta = {
    description = "Powerful AI agent that gives you freedom to choose your models and control your data";
    homepage = "https://agent-one.dev";
    license = lib.licenses.agpl3Plus;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "agent-one";
  };
})
