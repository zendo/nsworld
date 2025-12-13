{ ... }:
{
  # https://codeberg.org/dnkl/fuzzel/src/branch/master/doc/fuzzel.ini.5.scd
  programs.fuzzel = {
    enable = true;
    main = {
      font = "Maple Mono:size=12";
      icon-theme = "Papirus";
      terminal = "ghostty";
      dpi-aware = "no";
      lines = 8;
      width = 60;
      line-height = 30;
      horizontal-pad = 20;
    };
    border = {
      width = 2;
      radius = 18;
    };
    colors = {
      background = "16161eff";
      border = "7aa2f7aa";
      match = "2ac3deff";
      selection = "343a55ff";
      selection-match = "2ac3deff";
      selection-text = "c0caf5ff";
      text = "c0caf5ff";
    };
  };
}
