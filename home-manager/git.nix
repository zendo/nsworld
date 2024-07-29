{ config, ... }:
{
  programs.git = {
    enable = true;
    userName = "zendo";
    userEmail = "linzway@qq.com";
    aliases = {
      st = "status -sb";
      ds = "diff --stat";
      undo = "reset --hard HEAD~1";
      patch = "format-patch --stdout HEAD~1";
      rank = "shortlog -s -n --no-merges";
      lg = "log --graph --decorate --all --oneline";
      ll = "log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr %an)%Creset' --abbrev-commit --date=relative";
      unstage = "reset HEAD --";
      quick-rebase = "rebase --interactive --autostash --committer-date-is-author-date";
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
  };

  # programs.lazygit = {
  #   enable = true;
  # };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "zendo";
        email = "linzway@qq.com";
      };
    };
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      # Host github.com
      #   HostName ssh.github.com
      #   Port 443

      Host yoga
        HostName 192.168.2.118
        Port 22
        User iab

      Host svp
        HostName 192.168.2.197
        Port 22
        User zendo

      Host rmt
        HostName 192.168.122.85
        Port 22
        User aaa

      #ProxyCommand nc -X 5 -x 127.0.0.1:7890 %h %p
    '';
  };
}
