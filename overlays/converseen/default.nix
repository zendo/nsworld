{ lib
, stdenv
, fetchFromGitHub
, qttools
, wrapQtAppsHook
, cmake
, pkg-config
, imagemagick
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "converseen";
  version = "0.9.9.6";

  src = fetchFromGitHub {
    owner = "Faster3ck";
    repo = "Converseen";
    rev = "v${version}";
    sha256 = "sha256-mpzIZc8a8SX6DL4ZJSuGOAPrFQdFpbcWqBNmzdrDGaM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    imagemagick
  ];

  # postPatch = ''
  #   substituteInPlace converseen.pro \
  #     --replace "/usr" "Sout"
  # '';

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    description = "Batch image converter and resizer";
    homepage = "https://github.com/Faster3ck/Converseen";
    changelog = "https://github.com/Faster3ck/Converseen/releases/tag/${src.rev}";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ zendo ];
  };
}
