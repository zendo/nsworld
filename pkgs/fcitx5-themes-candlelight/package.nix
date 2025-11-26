{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  jdupes,
}:

stdenvNoCC.mkDerivation {
  pname = "fcitx5-themes-candlelight";
  version = "0-unstable-2025-11-07";

  src = fetchFromGitHub {
    owner = "thep0y";
    repo = "fcitx5-themes-candlelight";
    rev = "653677b0454569f41c815b3d262a57e42c90ee05";
    hash = "sha256-dN77aUt1qkN177BZOfrT6O72Qp0J2jlM2mGNxI0cBnA=";
  };

  nativeBuildInputs = [ jdupes ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fcitx5/themes
    cp -r {autumn,spring,summer,winter} \
    {green,transparent-green,macOS-dark,macOS-light} \
    $out/share/fcitx5/themes
    jdupes --quiet --link-soft --recurse $out/share

    runHook postInstall
  '';

  meta = {
    description = "Sleek style skins for fcitx5";
    homepage = "https://github.com/thep0y/fcitx5-themes-candlelight";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ zendo ];
  };
}
