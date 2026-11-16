{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  python3,
  ostree,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "flatpak-extract";
  version = "0-unstable-2026-11-06";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "faveoled";
    repo = "flatpak-extract";
    rev = "80913c082264bf667d41e5816f8ba5eb4e76f8c9";
    hash = "sha256-wE0RWJJQJMMMXQgU/wWvhps1Cwr+14GGiuPow18Q5M8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ python3 ];

  postPatch = ''
    substituteInPlace local/flatpak-extract/flatpak-extract.py \
      --replace-fail "--mode=bare-user" "--mode=archive"
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 local/flatpak-extract/flatpak-extract.py $out/bin/$pname

    wrapProgram $out/bin/$pname \
      --prefix PATH : ${lib.makeBinPath [ ostree ]}
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--flake"
      "--version=branch"
    ];
  };

  meta = {
    description = "CLI app for extracting .flatpak files";
    homepage = "https://github.com/faveoled/flatpak-extract";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "flatpak-extract";
  };
})
