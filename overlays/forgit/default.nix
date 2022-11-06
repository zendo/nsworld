{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "forgit";
  version = "unstable-2022-10-14";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = pname;
    rev = "2872548075e63bc83a0b960e2813b16571998563";
    sha256 = "sha256-NKL4c4k9Nath8NQ3sWUTGUzp517jRX4v0qVaKMJSMrw=";
  };

  strictDeps = true;

  dontBuild = true;

  installPhase = ''
    install -Dm0644 forgit.plugin.zsh $out/share/zsh/plugins/forgit/forgit.plugin.zsh
  '';

  meta = with lib; {
    description = "Using git interactively with fzf";
    homepage = "https://github.com/wfxr/forgit";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [zendo];
  };
}
