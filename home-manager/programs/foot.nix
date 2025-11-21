{ ... }:
{
  # https://codeberg.org/dnkl/foot/src/branch/master/foot.ini
  programs.foot = {
    enable = true;
    # server.enable = true; # default: false
    settings = {
      main = {
        shell = "zsh -l";
        # term = "xterm-256color";
        font = "JetBrains Mono:size=11";
        initial-window-size-pixels = "800x600";
        pad = "8x8";
      };
      csd = {
        size = 0;
      };
      cursor = {
        blink = "yes";
      };
      bell = {
        system = "no";
      };
      key-bindings = {
        fullscreen = "F11";
        show-urls-launch = "Control+o";
        clipboard-copy = "Control+Shift+c Mod1+w XF86Copy";
        clipboard-paste = "Control+Shift+v Mod1+y Control+y XF86Paste";
        scrollback-up-page = "Shift+Page_Up Mod1+v";
        scrollback-down-page = "Shift+Page_Down Control+v";
      };
      colors = {
        alpha = "0.95";
        foreground = "DEDEDE";
        background = "1B1B1B";
        regular0 = "2C2E36"; # black
        regular1 = "E27373"; # red
        regular2 = "A5C261"; # green
        regular3 = "FFBA7B"; # yellow
        regular4 = "6DA0C0"; # blue
        regular5 = "C79EC4"; # magenta
        regular6 = "8CD0D3"; # cyan
        regular7 = "DEDEDE"; # white
        bright0 = "777777"; # bright black
        bright1 = "FFA1A1"; # bright red
        bright2 = "BDDEAB"; # bright green
        bright3 = "FFDCA0"; # bright yellow
        bright4 = "B1D8F6"; # bright blue
        bright5 = "FBDAFF"; # bright magenta
        bright6 = "99EBEE"; # bright cyan
        bright7 = "FFFFFF"; # bright white
      };
    };
  };
}
