{ ... }:
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        # lock_cmd = "pidof swaylock || swaylock";
        before_sleep_cmd = "loginctl lock-session";
        # after_sleep_cmd = "hyprctl dispatch dpms on";
        after_sleep_cmd = "niri msg action power-on-monitors";
      };
      listener = [
        {
          timeout = 200;
          on-timeout = "brightnessctl -s s 10%";
          on-resume = "brightnessctl -r";
        }
        # keyboard backlight
        # dms brightness list
        {
          timeout = 250;
          on-timeout = "brightnessctl -sd platform::kbd_backlight set 0";
          on-resume = "brightnessctl -rd platform::kbd_backlight";
        }
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 360;
          # on-timeout = "hyprctl dispatch dpms off";
          # on-resume = "hyprctl dispatch dpms on";
          on-timeout = "niri msg action power-off-monitors";
          on-resume = "niri msg action power-on-monitors";
        }
        {
          timeout = 1800; # 30mins
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
