# https://github.com/Curious-r/nix-packages/tree/main/pkgs/by-name/sp/sprout
{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  version = "0.0.31";

  sources = {
    x86_64-linux = {
      asset = "sprout-x86_64.efi";
      hash = "sha256-/6BF8vkTN/OCa7sl18xqKJJ84dfv+yVi9dV6xug4kJU=";
    };
    aarch64-linux = {
      asset = "sprout-aarch64.efi";
      hash = "sha256-mSjV+g7dit3nTrUT02biuLn+CxLTjzuKrr47t96Viks=";
    };
  };

  system = stdenvNoCC.hostPlatform.system;

  source = sources.${system} or (throw "sprout: no prebuilt EFI binary is published for ${system}");
in
stdenvNoCC.mkDerivation {
  pname = "sprout";
  inherit version;

  src = fetchurl {
    url = "https://github.com/edera-dev/sprout/releases/download/v${version}/${source.asset}";
    hash = source.hash;
  };

  dontUnpack = true;

  installPhase = ''
    install -Dm644 "$src" "$out/lib/sprout/sprout.efi"
  '';

  meta = {
    description = "Programmable UEFI bootloader";
    homepage = "https://github.com/edera-dev/sprout";
    license = lib.licenses.asl20;
    platforms = lib.attrNames sources;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
