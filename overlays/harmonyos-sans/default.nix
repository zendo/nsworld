{
  lib,
  fetchzip,
}:
fetchzip {
  url = "https://communityfile-drcn.op.hicloud.com/FileServer/getFile/cmtyPub/011/111/111/0000000000011111111.20211104104632.29664895974930825801937957883629:50521103025534:2800:1C62D8D976C9EAB505E2AAE22BD5B04FB5E6E311A8C39626B70F3F5BCF941EF9.zip?needInitFileName=true";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/harmonyos-sans
  '';

  sha256 = "sha256-Dsj11f4/dw1v0S7Op/cG4zl2VxynRcH3eSAXPpe9Rn0=";

  meta = with lib; {
    description = "A chinese font from HuaWei";
    homepage = "https://developer.harmonyos.com/cn/docs/design/font-0000001157868583";
    license = licenses.free;
    maintainers = with maintainers; [zendo];
    platforms = platforms.all;
  };
}
