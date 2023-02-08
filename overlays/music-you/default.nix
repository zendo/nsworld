{ lib
, buildNpmPackage
, fetchFromGitHub
, electron
}:
# WIP!!!
buildNpmPackage rec {
  pname = "music-you";
  version = "2.0.9";

  src = fetchFromGitHub {
    owner = "GuMengYu";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-isG3r4CU/pAiWzbYLIHt7rs3Y+Pwei215EJn8NrL2vk=";
  };

  npmDepsHash = "sha256-nx6+jnQJL/DgTXV71AJJw1GtnFrhE9bFQscrz7e4TH4=";

  # dontNpmBuild = true;

  # makeCacheWritable = true;
  # npmFlags = [ "--legacy-peer-deps" ];

  # The prepack script runs the build script, which we'd rather do in the build phase.
  npmPackFlags = [ "--ignore-scripts" ];

  NODE_OPTIONS = "--openssl-legacy-provider";

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # nativeBuildInputs = [
  # ];

  # buildInputs = [
  # ];

  meta = with lib; {
    description = "一个美观简约的Material Design 3 (Material You) 风格网易云音乐播放器pc客户端";
    homepage = "https://github.com/GuMengYu/music-you";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
