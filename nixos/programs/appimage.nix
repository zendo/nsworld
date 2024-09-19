{ pkgs, ... }:
{
  programs.appimage = {
    # binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs =
        pkgs: with pkgs; [
          libthai
          libsecret
          libepoxy
        ];
    };
  };
}
