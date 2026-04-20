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
          extensions = with pkgs.vscode-extensions; [
            codeinchinese.englishchinesedictionary
            ms-ceintl.vscode-language-pack-zh-hans
            kahole.magit
            editorconfig.editorconfig
            tamasfe.even-better-toml
            file-icons.file-icons
            golang.go
            mattn.lisp
            vadimmelnicuk.meo # markdown
            jnoortheen.nix-ide
            eserozvataf.one-dark-pro-monokai-darker # theme
            tootone.org-mode
            esbenp.prettier-vscode
            ms-python.python
            nefrob.vscode-just-syntax
            foxundermoon.shell-format
            # kdl-org.kdl
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
