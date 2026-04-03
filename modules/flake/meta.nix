{ lib, ... }:
{
  options.topVars = {
    user = lib.mkOption {
      type = lib.types.singleLineStr;
      description = "username";
    };

    host = lib.mkOption {
      type = lib.types.singleLineStr;
      description = "hostname";
    };

    # user = lib.mkOption {
    #   type = lib.types.submodule {
    #     options = {
    #       name = lib.mkOption { ... };
    #       uid = lib.mkOption { ... };
    #     };
    #   };
    # };
  };
}
