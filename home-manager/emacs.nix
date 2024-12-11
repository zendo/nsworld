{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gcc
    cmake
    gnumake
    python3
    # nil
    nixd
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacs30-pgtk;
    extraPackages =
      epkgs: with epkgs; [
        jinx
        vterm
        emojify
        emacsql-sqlite
        # lsp-bridge
        # pdf-tools
        # telega
        (treesit-grammars.with-grammars (p: builtins.attrValues p))
      ];
    extraConfig = ''
      (display-time-mode 1)
    '';
  };
}
