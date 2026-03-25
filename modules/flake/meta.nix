# Declares a top-level option that is used in other modules.
# flake.debug.me
{ lib, ... }:
{
  options = {
    me = {
      username = lib.mkOption {
        type = lib.types.str;
        description = "Your username as shown by `id -un`";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "Your full name for use in Git config";
      };
      email = lib.mkOption {
        type = lib.types.str;
        description = "Your email for use in Git config";
      };
      namespace = lib.mkOption {
        type = lib.types.str;
      };
    };
  };
}
