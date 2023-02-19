{ stdenvNoCC, lib }:

stdenvNoCC.mkDerivation rec {
  name = "nixos-helper";

  src = ./nixos-helper.sh;

  bashComp = ./ns.bash;

  dontUnpack = true;

  installPhase = ''
    install -Dm755 "$src" "$out/bin/ns"
    install -D ${bashComp} $out/share/bash-completion/completions/ns.bash
  '';

  meta = with lib; {
    description = "My nixos helper";
    homepage = "https://github.com/zendo/nsworld";
    mainProgram = "ns";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ zendo ];
  };
}
