# Mirror tweak

```shell
sudo bash -c "echo 'solver.onlyRequires = true' >> /etc/zypp/zypp.conf"

sudo zypper mr -da
sudo zypper ar -fcg https://mirror.sjtu.edu.cn/opensuse/tumbleweed/repo/oss/ sjtu-oss
sudo zypper ar -fcg https://mirror.sjtu.edu.cn/opensuse/tumbleweed/repo/non-oss/ sjtu-non-oss
mirrors.sustech.edu.cn
```

# Codecs

```shell
sudo zypper ar -f https://mirrors.bfsu.edu.cn/packman/suse/openSUSE_Tumbleweed/ packman
sudo zypper dup --from packman --allow-vendor-change
sudo zypper in x264 x265 faac faad2 lame libxine2 libxine2-codecs vlc-codecs vlc-codec-gstreamer ogmtools gstreamer-plugins-bad-orig-addon gstreamer-plugins-good-extra gstreamer-plugins-ugly-orig-addon chromium-ffmpeg-extra
```

# Essential apps

opi vscode 

patterns-devel-C-C++-devel_C_C++ libopenssl-devel

# Installtion

## Gnome
- del: libreoffice evolution pidgin polari bijiben transmission yelp ibus-table fcitx opensuse-welcome PackageKit 
- add: pipewire-pulseaudio hack terminus-bitmap-fonts 
- in: noto-sans-sc-fonts firewall-config gnome-font-viewer

## KDE
- del: Games Office KDE PIM
- del: plasma5-pk-updates konversation ibus fcitx- skanlite opensuse-welcome
- add: pipewire-pulseaudio gnome-color-manager colord-kde

# zypper usage
- zypper rm -u xxx 卸载软件和其依赖
- zypper mr -d 4 禁用4号源
- zypper clean -a
- zypper se -i 搜索已装软件
- zypper pa --orphaned 列出孤立软件
- zypper pa --unneeded
- zypper pt
- zypper in -t pattern lamp_server

# Links

<https://opensuse.github.io/openSUSE-docs-revamped-temp/index.html>

<https://cnzhx.net/blog/index-of-notes-on-t470s-and-opensuse/>

<https://alexandriteos.org/>
