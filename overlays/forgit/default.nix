{
  lib,
  fetchFromGitHub,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "forgit";
  version = "unstable-2022-05-29";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = "forgit";
    rev = "6385f85360b6fe0a1ac19cd5ce595b4f3921a2a7";
    sha256 = "sha256-sWWv9UJR1K8Q5ZTcU7xjJtk8hTRXywVjSL2gQ5Kqj0M=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    plugindir="$out/share/forgit"
    mkdir -p "$plugindir"
    cp -r * "$plugindir"/
  '';

  meta = with lib; {
    description = "Using git interactively with fzf";
    homepage = "https://github.com/wfxr/forgit";
    license = licenses.mit;
    maintainers = with maintainers; [zendo];
    platforms = platforms.all;
  };
}
