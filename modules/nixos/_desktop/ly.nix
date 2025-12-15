{ ... }:
{
  services.displayManager.ly = {
    enable = true;
    # https://codeberg.org/fairyglade/ly/src/branch/master/res/config.ini
    settings = {
      animation = "matrix";
      bigclock = true;
      session_log = null;
      clear_password = true;
      hide_version_string = true;
    };
  };
}
