{
  lib,
  fetchgit,
  stdenv,
}:
 stdenv.mkDerivation rec {
    pname = "forgit";
    version = "latest";

    src = fetchgit {
      url = "https://github.com/wfxr/forgit.git";
      sha256 = "sha256-SjSdsbuXVnirrhdyfexDifd1E8unS1o2SqcEVFNfmi0=";
    };

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      plugindir="$out/share/forgit"
      mkdir -p "$plugindir"
      cp -r * "$plugindir"/
    '';

    meta = with lib; {
      description =
        "A utility tool powered by fzf for using git interactively.";
        homepage = "https://github.com/wfxr/forgit";
      license = licenses.mit;
      platforms = platforms.unix;
    };
  }
