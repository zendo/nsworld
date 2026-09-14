{
  flake.modules.homeManager.vscode =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        vscode
      ];

      programs.vscode = {
        # enable = true;
        profiles.default = {
          enableExtensionUpdateCheck = false;
          enableUpdateCheck = false;
          extensions = with pkgs.vscode-extensions; [
            ms-ceintl.vscode-language-pack-zh-hans
            ms-azuretools.vscode-docker
            ms-vscode-remote.remote-ssh
            ms-vscode.cpptools
            ms-vscode.cmake-tools
            ms-vscode.makefile-tools
            ms-python.python
            ms-pyright.pyright

            file-icons.file-icons
            editorconfig.editorconfig
            # codeinchinese.englishchinesedictionary
            # eserozvataf.one-dark-pro-monokai-darker # theme
            # vadimmelnicuk.meo # markdown
            golang.go
            mattn.lisp
            tamasfe.even-better-toml
            jnoortheen.nix-ide
            # tootone.org-mode
            esbenp.prettier-vscode
            nefrob.vscode-just-syntax
            foxundermoon.shell-format
            # kdl-org.kdl
            kahole.magit
          ];
          userSettings = {
            "files.autoSave" = "onFocusChange";
            "editor.fontSize" = 13;
            "editor.fontFamily" =
              "'JetBrains Mono', 'Hack', 'Droid Sans Mono', monospace, 'Droid Sans Fallback'";
            "update.mode" = "none";
            "nix.formatterPath" = "nixfmt";
            # "workbench.colorTheme" = "Monokai";
            # "workbench.commandPalette.preserveInput" = true;
            # "workbench.editor.enablePreviewFromCodeNavigation" = true;
            # "workbench.iconTheme" = "vscode-icons";
            "[yaml]" = {
              "editor.defaultFormatter" = "esbenp.prettier-vscode";
            };
          };
          # keybindings = [
          #   {
          #     key = "ctrl+m";
          #     command = "editor.action.clipboardCopyAction";
          #     when = "textInputFocus";
          #   }
          # ];
        };
      };
    };
}
