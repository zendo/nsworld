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
        sqlite3
        # lsp-bridge
        # pdf-tools
        # telega
        treesit-grammars.with-all-grammars
      ];
    extraConfig = ''
      (display-time-mode 1)
    '';
  };
}
