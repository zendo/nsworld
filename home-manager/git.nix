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
      pm = "push -u origin main";
      lg = "log --graph --decorate --all --oneline";
    };
    extraConfig = {
      init.defaultBranch = "main";
      # pull.rebase = true;
      # merge.ff = "only";
      # core.editor = "vim";
      # credential.helper = "store";
      safe.directory = [
        # "/home/iab/nsworld"
        # "/home/iab/devel/nixpkgs"
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

  # programs.ssh = {
  #   enable = true;
  #   # extraConfig = ''
  #   #   ProxyCommand nc -X 5 -x 127.0.0.1:20170 %h %p
  #   # '';
  # };
}
