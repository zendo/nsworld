{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fcitx5-fluent";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Reverier-Xu";
    repo = "Fluent-fcitx5";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wefleY3dMM3rk1/cZn36n2WWLuRF9dTi3aeDDNiR6NU=";
  };

  installPhase = ''
    mkdir -p $out/share/fcitx5/themes
    cp -r ./* $_
  '';

  meta = {
    description = "A Fluent-Design dark theme with blur effect and shadow for fcitx5";
    homepage = "https://github.com/Reverier-Xu/Fluent-fcitx5";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ zendo ];
  };
})
