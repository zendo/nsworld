{
  flake.modules.nixos.nix-ld =
    { pkgs, ... }:
    {
      programs.nix-ld = {
        enable = true;
        libraries = [
          (pkgs.runCommand "steamrun-lib" { } "mkdir $out; ln -s ${pkgs.steam-run.fhsenv}/usr/lib64 $out/lib")
        ];
      };
    };

}
