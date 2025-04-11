{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  jdupes,
}:

stdenvNoCC.mkDerivation {
  pname = "fcitx5-themes-candlelight";
  version = "0-unstable-2024-08-03";

  src = fetchFromGitHub {
    owner = "thep0y";
    repo = "fcitx5-themes-candlelight";
    rev = "d4146d3d3f7a276a8daa2847c3e5c08de20485da";
    hash = "sha256-/IdN69izB30rl1gswsXivYtpAeCUdahP7oy06XJXo0I=";
  };

  nativeBuildInputs = [ jdupes ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fcitx5/themes
    find . -type d ! -name "images" ! -name "." -exec cp -r {} $out/share/fcitx5/themes \;
    jdupes --quiet --link-soft --recurse $out/share

    runHook postInstall
  '';

  meta = {
    description = "fcitx5的简约风格皮肤——烛光";
    homepage = "https://github.com/thep0y/fcitx5-themes-candlelight";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ zendo ];
  };
}
