{
  lib,
  stdenv,
  bun2nix,
  fetchFromGitHub,

  makeBinaryWrapper,
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

  writeShellScript,
  nix-update,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tfm-tui";
  version = "1.0.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "clarkarch";
    repo = "tfm-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L60HP1q/xbOLeHK1Cfu7MnA6b9ZP0xXQnF8UvFCzARE=";
  };

  bunDeps = bun2nix.fetchBunDeps {
    bunNix = ./bun.nix;
  };

  nativeBuildInputs = [
    bun2nix.hook
    makeBinaryWrapper
  ];

  buildPhase = ''
    bun run compile
  '';

  installPhase = ''
    mkdir -p $out/{dist,bin}
    cp -R ./dist $out
    ln -s $out/dist/tfm $out/bin/tfm
  '';

  postInstall = ''
    wrapProgram $out/bin/${finalAttrs.meta.mainProgram} \
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

  # nix-update --flake tfm-tui --use-update-script
  passthru.updateScript = writeShellScript "update-tfm-tui" ''
    set -e

    ${lib.getExe nix-update} --flake tfm-tui

    src=$(nix eval --raw .#tfm-tui.src.outPath)

    ${lib.getExe bun2nix} \
      -l "$src/bun.lock" \
      -o pkgs/tfm-tui/bun.nix
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
