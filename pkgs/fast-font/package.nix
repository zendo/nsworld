{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "fast-font";
  version = "0-unstable-2025-03-30";

  src = fetchFromGitHub {
    owner = "Born2Root";
    repo = "Fast-Font";
    rev = "f1ec8f9426c5907ac0e1f0d30464c5ac07c1f844";
    hash = "sha256-sbm3zOdvdrVA4j/oU1InQ04hroQw5XHlN9p233FU0TA=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype/fast-font
    install -Dm644 *.ttf $out/share/fonts/truetype/fast-font

    runHook postInstall
  '';

  meta = {
    description = "A font to help you read faster.";
    homepage = "https://github.com/Born2Root/Fast-Font";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ zendo ];
  };
}
