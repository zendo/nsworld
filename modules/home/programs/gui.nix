{
  flake.modules.homeManager.gui =
    { lib, pkgs, ... }:
    {
      home.packages = with pkgs; [
        kula
        elio
        nano-ffmpeg
        # open-orpheus
        # jhentai
        venera-kyosee

        # [ Social ]
        telegram-desktop # :webkitgtk
        # vesktop # discord
        # fractal
        # fluffychat
        # newsflash

        # [ Multimedia ]
        # mpd
        # rmpc
        # qmmp
        audacious
        # rhythmbox
        goodvibes
        # cliamp
        go-musicfox
        # splayer # :electron
        # qqmusic
        spotify
        # mousai
        songrec
        kooha
        # jamesdsp
        kazumi # anime
        # yt-dlp
        # vlc
        # ffmpeg
        # ciano

        # [ Image Manipulation ]
        # shutter
        # pinta
        contrast
        gradia
        satty # annotation

        # remmina # :webkitgtk
        # https://github.com/nix-community/home-manager/issues/5173
        (lib.hiPrio localsend)
        qbittorrent
        rclone-browser
        # deja-dup
        # vorta # borg backup

        # [ Reader ]
        # foliate # :webkitgtk
        readest # :webkitgtk
        # koodo-reader
        # comigo
        # yacreader
        # venera

        # [ OFFICE ]
        # obsidian
        # joplin-desktop
        # libreoffice-fresh
        # drawio
        # rnote # handwritten note
        # planify
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
        unrar # :unfree

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
        # libva-utils # vainfo
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
        # mission-center
      ];

      # programs.obs-studio = {
      #   enable = true;
      #   plugins = [ ];
      # };

      # programs.pandoc = {
      #   enable = true;
      # };
    };
}
