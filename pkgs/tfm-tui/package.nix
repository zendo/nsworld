{
  lib,
  bun2nix,
  fetchFromGitHub,

  makeWrapper,
  _7zz,
  ffmpeg-headless,
  glib,
  gnutar,
  imagemagick,
  librsvg,
  udisks,
  unzip,
  wl-clipboard,
  xdg-utils,
  zip,
}:

bun2nix.mkDerivation (finalAttrs: {
  pname = "tfm-tui";
  version = "0.1.0-beta.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "clarkarch";
    repo = "tfm-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XHpYJMcvBxL4x8JxO+RKE0ll/GtJljxVSqtl+aBrnRU=";
  };

  bunDeps = bun2nix.fetchBunDeps {
    bunNix = ./bun.nix;
  };

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    bun run compile
  '';

  installPhase = ''
    mkdir -p $out/{dist,bin}
    cp -R ./dist $out
    ln -s $out/dist/tfm $out/bin/tfm
  '';

  postFixup = ''
    wrapProgram $out/bin/tfm \
      --prefix PATH : ${
        lib.makeBinPath [
          _7zz
          ffmpeg-headless
          glib
          gnutar
          imagemagick
          librsvg
          udisks
          unzip
          wl-clipboard
          xdg-utils
          zip
        ]
      }
  '';

  passthru.updateScript = ''
    bun2nix -o bun.nix
  '';

  meta = {
    description = "Modern mouse-first terminal file manager";
    homepage = "https://clarkarch.github.io/tfm-tui";
    downloadPage = "https://github.com/clarkarch/tfm-tui";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "tfm";
  };
})
