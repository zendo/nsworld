{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vscode
  ];

  programs.vscode = {
    # enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        ms-ceintl.vscode-language-pack-zh-hans
        file-icons.file-icons
        eamodio.gitlens
        editorconfig.editorconfig
        foxundermoon.shell-format
        tamasfe.even-better-toml
        # kdl-org.kdl
        nefrob.vscode-just-syntax
        esbenp.prettier-vscode
        golang.go
        mattn.lisp
        ms-python.python
        jnoortheen.nix-ide
        # ms-vscode.cmake-tools
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
}
