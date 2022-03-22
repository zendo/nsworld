{
  lib,
  fetchzip,
}:
fetchzip {
  url = "https://communityfile-drcn.op.hicloud.com/FileServer/getFile/cmtyPub/011/111/111/0000000000011111111.20211104104632.29664895974930825801937957883629:50521103025534:2800:1C62D8D976C9EAB505E2AAE22BD5B04FB5E6E311A8C39626B70F3F5BCF941EF9.zip?needInitFileName=true";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/hack
  '';

  sha256 = "sha256-9iJEsN1hcvldP0domiCn4AVttJWFSGgeg2jSuVoazls=";

  meta = with lib; {
    description = "A typeface designed for source code";
    longDescription = ''
      Hack is hand groomed and optically balanced to be a workhorse face for
      code. It has deep roots in the libre, open source typeface community and
      expands upon the contributions of the Bitstream Vera & DejaVu projects.
      The face has been re-designed with a larger glyph set, modifications of
      the original glyph shapes, and meticulous attention to metrics.
    '';
    homepage = "https://developer.harmonyos.com/cn/docs/design/font-0000001157868583";

    /*
     "The font binaries are released under a license that permits unlimited
     print, desktop, and web use for commercial and non-commercial
     applications. It may be embedded and distributed in documents and
     applications. The source is released in the widely supported UFO format
     and may be modified to derive new typeface branches. The full text of
     the license is available in LICENSE.md" (From the GitHub page)
     */
    license = licenses.free;
    maintainers = with maintainers; [dywedir];
    platforms = platforms.all;
  };
}
