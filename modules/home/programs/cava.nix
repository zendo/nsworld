{ inputs, ... }:
{
  flake.modules.homeManager.cava =
    { pkgs, ... }:
    {
      programs.cava = {
        enable = true;
        package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.wrap-cava;
      };
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.wrap-cava = inputs.wrapper-modules.wrappers.cava.wrap {
        inherit pkgs;
        settings = {
          general = {
            bar_spacing = 1;
            bar_width = 2;
            frame_rate = 60;
          };
          color = {
            # Dracula
            gradient = 1;
            gradient_color_1 = "'#8BE9FD'";
            gradient_color_2 = "'#9AEDFE'";
            gradient_color_3 = "'#CAA9FA'";
            gradient_color_4 = "'#BD93F9'";
            gradient_color_5 = "'#FF92D0'";
            gradient_color_6 = "'#FF79C6'";
            gradient_color_7 = "'#FF6E67'";
            gradient_color_8 = "'#FF5555'";
          };
        };
      };
    };
}
