{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "rime-ice";
  version = "2025.04.06-unstable-2025-06-09";

  src = fetchFromGitHub {
    owner = "iDvel";
    repo = "rime-ice";
    rev = "5b94b7df626bffedc3fe05ee71511aa0272bfc36";
    hash = "sha256-RK5togo9YEQVSUL1bpkcsHmzK1V8IMe0adFB1T2hVoI=";
  };

  installPhase = ''
    mkdir -p $out/share/rime-data
    rm -r ./others
    cp default.yaml rime_ice_suggestion.yaml
    cp -r ./* $out/share/rime-data
  '';

  meta = {
    description = "雾凇拼音，功能齐全，词库体验良好，长期更新修订";
    homepage = "https://github.com/iDvel/rime-ice";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ zendo ];
  };
}
