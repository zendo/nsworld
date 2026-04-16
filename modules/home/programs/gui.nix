{
  flake.modules.homeManager.gui =
    { lib, pkgs, ... }:
    {
      home.packages = with pkgs; [
        comigo
        kula

        # [ AI ]
        codex
        opencode
        qwen-code

        # [ Social ]
        telegram-desktop # (webkitgtk)
        # vesktop # discord
        # fractal
        # fluffychat
        # newsflash
        # yacreader
        venera
        jhentai

        # [ Multimedia ]
        # mpd
        # rmpc
        # qmmp
        audacious
        # rhythmbox
        goodvibes
        cliamp
        go-musicfox
        splayer # (electron)
        # qqmusic
        spotify
        # mousai
        songrec
        kooha
        # jamesdsp
        # kazumi # anime
        # yt-dlp
        # vlc
        # ffmpeg
        # ciano
        # video-trimmer

        # [ Image Manipulation ]
        # shutter
        # pinta
        contrast
        # font-manager # (webkitgtk)
        # gcolor3
        gradia
        satty # annotation

        # remmina # (webkitgtk)
        # gnome-decoder
        # https://github.com/nix-community/home-manager/issues/5173
        (lib.hiPrio localsend)
        qbittorrent
        rclone-browser
        # lock
        # deja-dup
        # vorta

        # [ OFFICE ]
        # obsidian
        # joplin-desktop
        # libreoffice-fresh
        # drawio
        # rnote # handwritten note
        # foliate # (webkitgtk)
        # readest
        # koodo-reader
        # planify
        # ghostwriter # (qtwebengine)
        clapgrep
        meld
        # textpieces
        # devtoolbox
        # qalculate-gtk # scientific calculator

        # [ Terminal ]
        graphviz
        # imagemagick
        exiftool
        ffmpegthumbnailer
        # unar # free but oversize
        unrar # unfree

        # [ HARDWARE TOOLS ]
        parted
        gptfdisk
        efibootmgr
        # efitools
        # amdgpu_top
        # nvtopPackages.amd
        inxi
        lm_sensors
        lshw
        kmon # kernel modules
        hwinfo
        cpufetch
        usbutils
        dmidecode
        # glxinfo
        # libva-utils #vainfo
        # vulkan-tools
        cpufrequtils
        pciutils
        edid-decode
        read-edid
        xeyes
        wl-clipboard
        # libinput
        android-tools
        # squirreldisk
        resources
        # mission-center
      ];

      # programs.obs-studio = {
      #   enable = true;
      #   plugins = [ ];
      # };

      programs.pandoc = {
        enable = false;
      };
    };
}
