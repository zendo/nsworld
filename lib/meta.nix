{ config, lib, pkgs, ... }:
with pkgs.lib;
{
  options.meta = {
    username = mkOption {
      type = types.str;
      description = "The default username";
      default = "iab";
    };
    email = mkOption {
      type = types.str;
      description = "The default email";
      default = "linzway@qq.com";
    };
  };
}
