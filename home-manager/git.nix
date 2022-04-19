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
      ca = "commit -a -m";
      lg = "log --graph --decorate --all --oneline";
    };
    extraConfig = {
      safe.directory = "/home/iab/.nsworld";
    };
  };

  programs.git.delta = {
    enable = true;
  };

  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
  };
}
