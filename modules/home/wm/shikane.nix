{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wdisplays
    shikane
  ];

  # wdisplays // set the right outputs
  # install -Dm644 /dev/null ~/.config/shikane/config.toml
  # shikane &
  # shikanectl export $(uname -n)
  # fg shikane
  services.shikane = {
    enable = true;
    settings = {
      profile = [
        {
          name = "yoga";
          output = [
            {
              enable = true;
              search = [
                "m=0x8A90"
                "s="
                "v=Lenovo Group Limited"
              ];
              mode = "2880x1800@90Hz";
              position = "0,0";
              scale = 2;
              transform = "normal";
              adaptive_sync = false;
            }
          ];
        }
        {
          name = "svp";
          output = [
            {
              enable = true;
              search = [
                "m=VVX13F009G00"
                "s="
                "v=Panasonic Industry Company"
              ];
              mode = "1920x1080@60Hz";
              position = "0,0";
              scale = 1.2;
              transform = "normal";
              adaptive_sync = false;
            }
          ];
        }
      ];
    };
  };
}
