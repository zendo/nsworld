{stdenv}:
stdenv.mkDerivation {
  name = "nixos-scripts";

  src = ./nixos-scripts.sh;

  dontUnpack = true;

  installPhase = ''
    install -Dm755 "$src" "$out/bin/ns"
  '';
}
