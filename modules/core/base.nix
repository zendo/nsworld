{
  flake.modules.nixos.base =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      time.timeZone = lib.mkDefault "Asia/Shanghai";
      system.stateVersion = lib.mkDefault "26.05";

      environment.localBinInPath = true; # ~/.local/bin
      environment.sessionVariables = {
        # EDITOR = "emacsclient -c -a emacs";
        EDITOR = "fresh";
        VISUAL = "fresh";
        # PAGER = "moor";
        TERMINAL = "ghostty";
        NIXOS_OZONE_WL = 1; # Electron wayland native
        _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
      };

      services.btrfs.autoScrub.enable =
        config.fileSystems ? "/" && config.fileSystems."/".fsType == "btrfs";
      services.bcachefs.autoScrub.enable =
        config.fileSystems ? "/" && config.fileSystems."/".fsType == "bcachefs";

      documentation = {
        enable = lib.mkDefault false;
        # man.enable = lib.mkDefault false;
        doc.enable = lib.mkDefault false;
        info.enable = lib.mkDefault false;
        nixos.enable = lib.mkDefault false;
      };

      programs.command-not-found.enable = false;

      programs.nano = {
        enable = false;
        nanorc = ''
          set linenumbers
          set indicator
          set constantshow
          set guidestripe 80
          set spotlightcolor black,lightyellow
          set mouse
          set autoindent
          set tabsize 4
          set tabstospaces
          set smarthome
          set positionlog
          set zap
          bind ^Q exit all
          bind ^G cancel all
          bind ^S savefile main
          bind ^@ mark main
          bind ^C copy main
          bind ^V paste all
          bind ^X cut main
          bind ^Z undo main
          bind ^/ redo main
          bind ^F whereis all
          bind ^R replace main
          bind ^T gotoline main
        '';
      };
    };
}
