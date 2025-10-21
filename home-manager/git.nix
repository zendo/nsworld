{ ... }:
{
  programs.git = {
    enable = true;
    signing.format = "openpgp";
    settings = {
      user.name = "zendo";
      user.email = "linzway@qq.com";
      alias = {
        st = "status -sb";
        ds = "diff --stat";
        undo = "reset --hard HEAD~1";
        patch = "format-patch --stdout HEAD~1";
        rpatch = "reset --hard HEAD~1";
        rank = "shortlog -s -n --no-merges";
        ls = "log --stat --abbrev-commit";
        lg = "log --graph --decorate --all --oneline";
        ll = "log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr %an)%Creset' --abbrev-commit --date=relative";
        unstage = "reset HEAD --";
        quick-rebase = "rebase --interactive --autostash --committer-date-is-author-date";
        pr-pull = "!f() { git fetch upstream pull/$1/head:pr-$2-$1 && git checkout pr-$2-$1; }; f";
        sync-nixos-version = ''!git fetch upstream master && git merge "$(nixos-version --revision)"'';
      };
      extraConfig = {
        column.ui = "auto";
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
    }; # end of settings

    # Git Large File Storage
    lfs = {
      enable = true;
    };
  }; # end of programs.git

  programs.git-credential-oauth = {
    enable = true;
    # extraFlags = [
    #   "-device"
    # ];
  };

  # syntax-highlighting pager for git, diff, and grep output
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.gh = {
    # enable = true;
  };

  programs.lazygit = {
    # enable = true;
  };

  programs.jujutsu = {
    # enable = true;
    settings = {
      user = {
        name = "zendo";
        email = "linzway@qq.com";
      };
    };
  };
}
