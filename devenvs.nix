{ pkgs }:
{
  ###############################################
  ##  Shell
  ###############################################
  shell-env = {
    languages.shell.enable = true;
    enterShell = ''
      bash-language-server --version
      bats --version
      shellcheck --version
    '';
    # https://github.com/cachix/devenv/issues/528#issuecomment-1556108767
    containers = pkgs.lib.mkForce { };
  };

  apk-env = {
    android = {
      enable = true;
      flutter.enable = true;
    };
  };

  ###############################################
  ##  Golang
  ###############################################
  go-env = {
    languages.go = {
      enable = true;
    };
    packages = with pkgs; [
      gnumake
      golangci-lint
      yamllint
    ];
    scripts = {
      versions.exec = ''
        go version
        golangci-lint version
      '';
    };
    enterShell = ''
      versions
    '';
    # fix
    containers = pkgs.lib.mkForce { };
  };

  ###############################################
  ##  Rust
  ###############################################
  rust-env = {
    languages.rust = {
      enable = true;

      # add inputs: fenix.url = "github:nix-community/fenix";
      # channel = "nightly";

      components = [
        "rustc"
        "cargo"
        "clippy"
        "rustfmt"
        "rust-analyzer"
      ];
    };
    # fix
    containers = pkgs.lib.mkForce { };
  };
}
