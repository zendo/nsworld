{ config, pkgs, ... }: {

  programs.git = {
    enable = true;
    userName = "zendo";
    userEmail = "linzway@qq.com";
    aliases = {
      st = "status -sb";
      pm = "push -u origin main";
      undo = "reset --hard HEAD~1";
      patch = "format-patch --stdout HEAD~1";
      lg = "log --graph --decorate --all --oneline";
      ll = "log --pretty=format:'%Cred%h%Creset %Cblue%as%Creset %Cgreen%an%Creset %s %d'";
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
  #   #   ProxyCommand nc -X 5 -x 127.0.0.1:7890 %h %p
  #   # '';
  # };
}
