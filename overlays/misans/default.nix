{
  lib,
  fetchzip,
}:
fetchzip {
  url = "https://cdn.cnbj1.fds.api.mi-img.com/vipmlmodel/font/MiSans/MiSans.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/harmonyos-sans
  '';

  sha256 = "sha256-IvmiTbQKC9krT+9VIf+cc/FiT6m3KLm2uqdU8Wa+4hY=";

  meta = with lib; {
    description = "A chinese font from XiaoMi";
    homepage = "https://web.vip.miui.com/page/info/mio/mio/detail?postId=33935854&app_version=dev.20051&ref=MIUI13";
    license = licenses.free;
    maintainers = with maintainers; [zendo];
    platforms = platforms.all;
  };
}
