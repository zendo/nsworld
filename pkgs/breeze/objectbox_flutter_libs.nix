{
  lib,
  stdenv,
  fetchzip,
  replaceVars,
}:

{ version, src, ... }:

let
  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system}
      or (throw "objectbox_flutter_libs: ${stdenv.hostPlatform.system} is not supported");

  arch = selectSystem {
    x86_64-linux = "x64";
    aarch64-linux = "aarch64";
  };

  objectbox-c = fetchzip {
    name = "objectbox-linux-5.3.2";
    url = "https://github.com/objectbox/objectbox-c/releases/download/v5.3.2/objectbox-linux-${arch}.tar.gz";
    hash = selectSystem {
      x86_64-linux = "sha256-+4T1Y8N8c9YhuY+5ZAkDS8bOFhHMakfbzRZ9w0uaoqE=";
      aarch64-linux = "sha256-3E75s9QV31zc8aAN+2/GgGwqT5dlkWH+8qPDBbheYEs=";
    };
    stripRoot = false;
    meta.license = lib.licenses.unfree; # the release tarball has a proprietary shared library
  };
in
stdenv.mkDerivation {
  pname = "objectbox_flutter_libs";
  inherit version src;
  inherit (src) passthru;

  patches = [
    (replaceVars ./CMakeLists.patch {
      OBJECTBOX_SHARED_LIBRARY = "${objectbox-c}/lib/libobjectbox.so";
    })
  ];

  # objectbox_flutter_libs 5.3.2 ships its Linux CMakeLists.txt with CRLF line
  # endings, while the patch above uses LF endings.
  prePatch = ''
    sed -i 's/\r$//' linux/CMakeLists.txt
  '';

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';

  meta.sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
}
