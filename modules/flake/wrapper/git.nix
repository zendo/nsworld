# WIP
{ inputs, ... }:
let
  gitName = "zendo";
  gitEmail = "linzway@qq.com";
in
{
  perSystem =
    { pkgs, lib, ... }:
    {
      packages.wrapper-git = inputs.omniflake.flakes.nix-wrapper-modules.wrappers.git.wrap (
        { config, ... }: {
          inherit pkgs;
          runtimePkgs = with pkgs; [
            delta
            git-credential-oauth
          ];
          constructFiles.ignore = {
            relPath = "ignore";
            content = ''
              .csvignore
              .DS_Store
              .vscode
              .agent-shell
              .sentry-native
              *.drv
              *.qcow2
              result
              result-*
              .direnv
              .envrc
              *.py?
              __pycache__/
              .venv/
            '';
          };
          settings = {
            user.name = gitName;
            user.email = gitEmail;
            init.defaultBranch = "main";
            column.ui = "auto";
            core.excludesfile = config.constructFiles.ignore.path;
            core.pager = "${lib.getExe pkgs.delta}";
            interactive.diffFilter = "${lib.getExe pkgs.delta} --color-only";

            credential.helper = "${lib.getExe pkgs.git-credential-oauth}";
            # pull.rebase = true;
            # merge.ff = "only";
            # core.editor = "vim";
            # safe.directory = [
            #   "${config.home.homeDirectory}/nsworld"
            #   "${config.home.homeDirectory}/Projects/nixpkgs"
            # ];
            alias = {
              st = "status -sb";
              ds = "diff --stat";
              unstage = "reset HEAD --";
              undo = "reset --hard HEAD~1";
              patch = "format-patch --stdout HEAD~1";
              rpatch = "reset --hard HEAD~1";
              rank = "shortlog -s -n --no-merges";
              ls = "log --stat --abbrev-commit";
              lg = "log --graph --decorate --all --oneline";
              ll = "log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr %an)%Creset' --abbrev-commit --date=relative";
              pr-pull = "!f() { git fetch upstream pull/$1/head:pr-$2-$1 && git checkout pr-$2-$1; }; f";
            };
          };
        }
      );
    };
}
