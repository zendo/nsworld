{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

let
  pname = "nordwand-mono";
  version = "1.6.0";

  releaseAsset =
    asset: hash:
    fetchzip {
      name = asset;
      url = "https://github.com/tywr/Nordwand-Mono/releases/download/${version}/${asset}.zip";
      stripRoot = false;
      inherit hash;
    };
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  srcs = [
    (releaseAsset "NordwandMono-TTF" "sha256-dufxazKlfJ4u0XuzKYLXDlBQa8KkQJFqDR1VK/AOsCw=")
    (releaseAsset "NordwandMono-OTF" "sha256-d0iQswFpolTVdXK6YsyNuOb5JkzxiB7fckF8IQnxB+E=")
    (releaseAsset "NordwandMono-WOFF2" "sha256-OrKc4ywO/eZ7nVT/3/hNobt+ssCLtb2WcS+aPz9WJns=")
  ];

  sourceRoot = ".";

  nativeBuildInputs = [ installFonts ];

  dontBuild = true;

  # installFonts globs the tree, so the default installPhase (which only runs
  # the font hook) is enough.
  installPhase = ''
    runHook preInstall
    runHook postInstall
  '';

  outputs = [
    "out"
    "webfont"
  ];

  meta = {
    description = "Compact monospace neo-grotesque font designed for developers (and adventurers)";
    homepage = "https://tywr.github.io/Nordwand-Mono";
    downloadPage = "https://github.com/tywr/Nordwand-Mono";
    changelog = "https://github.com/tywr/Nordwand-Mono/releases/tag/${version}";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ zendo ];
  };
}
