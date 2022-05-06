{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "zendo";
    userEmail = "linzway@qq.com";
    aliases = {
      st = "status -sb";
      unstage = "reset HEAD --";
      pr = "pull --rebase";
      pm = "push -u origin main";
      addp = "add --patch";
      comp = "commit --patch";
      cc = "commit -a -m";
      lg = "log --graph --decorate --all --oneline";
    };
    extraConfig = {
      safe.directory = [
        "/home/iab/.nsworld"
        "/home/iab/devel/nixpkgs"
      ];
    };
  };

  programs.git.delta = {
    enable = true;
  };

  # Git Large File Storage
  programs.git.lfs = {
    enable = true;
  };

  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
  };

  programs.ssh = {
    enable = true;
    # extraConfig = ''
    #   ProxyCommand nc -X 5 -x 127.0.0.1:20170 %h %p
    # '';
  };
}
