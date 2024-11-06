{ lib, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  name = "ns";
  src = ./ns;

  dontUnpack = true;

  installPhase = ''
    install -Dm755 "$src" "$out/bin/ns"
    install -D ${./ns.bash} $out/share/bash-completion/completions/ns.bash
  '';

  meta = {
    description = "My nixos helper tool";
    homepage = "https://github.com/zendo/nsworld";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ zendo ];
  };
}
