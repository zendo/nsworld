{
  lib,
  python3,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
  libadwaita,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "lfy";
  version = "0.2.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "ldrfy";
    repo = "lfy";
    rev = "v${version}";
    hash = "sha256-8zIV8Uy5U+z5m9l1VCKXCz3clprScABB7eV/WP5zRrk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
  ];

  dependencies = with python3.pkgs; [
    pygobject3
    requests
  ];

  # prevent double wrapping
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Simple translate app, support baidu tencent google bing aliyun huoshan";
    homepage = "https://ldr.cool/lfy";
    downloadPage = "https://github.com/ldrfy/lfy";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "lfy";
  };
}
