{
  lib,
  stdenvNoCC,
  installShellFiles,
}:

stdenvNoCC.mkDerivation {
  name = "ns";
  src = ./ns;

  dontUnpack = true;

  nativeBuildInputs = [
    installShellFiles
  ];

  installPhase = ''
    install -Dm755 "$src" "$out/bin/ns"
    installShellCompletion \
      --bash ${./ns.bash} \
      --fish ${./ns.fish}
  '';

  meta = {
    description = "My nixos helper tool";
    homepage = "https://github.com/zendo/nsworld";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ zendo ];
  };
}
