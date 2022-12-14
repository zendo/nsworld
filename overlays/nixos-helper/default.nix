{ stdenv }:
stdenv.mkDerivation rec {
  name = "nixos-helper";

  src = ./nixos-helper.sh;

  bashcompletions = ./bCompletions.sh;
  zshcompletions = ./zCompletions.sh;

  dontUnpack = true;

  installPhase = ''
    install -Dm755 "$src" "$out/bin/ns"
    install -Dm755 ${bashcompletions} $out/share/bash-completion/completions/ns.bash
    # install -Dm755 ${zshcompletions} $out/share/zsh/site-functions/_ns
  '';
}
