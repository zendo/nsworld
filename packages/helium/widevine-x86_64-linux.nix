{
  lib,
  stdenv,
  fetchurl,
  go-crx3,
  autoPatchelfHook,
  gcc-unwrapped,
  glibc,
}: let
  manifest = {
    platform_key = "Linux_x86_64-gcc3";
    url = "https://edgedl.me.gvt1.com/edgedl/release2/chrome_component/aclxnidwwkj5di3vduduj2gqpgpq_4.10.2891.0/oimompecagnajdejgnnjijobebaeigek_4.10.2891.0_linux_b4hin3q5s66ws2322cyyfp35lu.crx3";
    sri = "sha512-8S/4FRQQmQAO9wJ7QGJg8KUVxUQgm5/oEl6l9N2/WGAdMCIqxBoBPrCkPadrpwQUpK0WYX2fIZ8Zzfx3lNm8lA==";
    version = "4.10.2891.0";
  };
in
  stdenv.mkDerivation {
    pname = "helium-widevine";
    version = manifest.version;

    src = fetchurl {
      url = manifest.url;
      hash = manifest.sri;
    };

    nativeBuildInputs = [
      go-crx3
      autoPatchelfHook
    ];

    buildInputs = [
      glibc
      gcc-unwrapped.lib
      stdenv.cc.cc.lib
    ];

    unpackPhase = ''
      unpackDir="src"
      cp "$src" "$unpackDir".crx
      crx3 unpack "$unpackDir".crx
      cd "$unpackDir"
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/helium/WidevineCdm/_platform_specific/linux_x64
      install -vD manifest.json $out/share/helium/WidevineCdm/manifest.json
      install -vD LICENSE $out/share/helium/WidevineCdm/LICENSE.txt
      install -vD _platform_specific/linux_x64/libwidevinecdm.so $out/share/helium/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so

      echo "Dependencies of libwidevinecdm.so:"
      ldd $out/share/helium/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so || true

      runHook postInstall
    '';

    postFixup = ''
      patchelf --set-rpath "${lib.makeLibraryPath [glibc gcc-unwrapped.lib stdenv.cc.cc.lib]}" \
        $out/share/helium/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so
    '';
  }
