{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "goeist";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "shadcn-labs";
    repo = "goeist-font";
    tag = "v${finalAttrs.version}";
    hash = "sha256-01LCLjuJHpKIYlbbaPLlRECzQk5DM8gsjYePuOaEYSU=";
  };

  nativeBuildInputs = [ installFonts ];

  dontBuild = true;

  # installFonts globs the whole tree, which would also pick up the unrounded
  # Geist reference fonts under sources/*/upstream.
  sourceRoot = "${finalAttrs.src.name}/fonts";

  installPhase = ''
    runHook preInstall
    runHook postInstall
  '';

  outputs = [
    "out"
    "webfont"
  ];

  meta = {
    description = "Rounded variant of Geist font";
    homepage = "https://github.com/shadcn-labs/goeist-font";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ zendo ];
  };
})
