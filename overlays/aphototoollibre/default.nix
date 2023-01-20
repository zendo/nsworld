{ lib
, stdenv
, fetchFromGitHub
, qmake
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "aphototoollibre";
  version = "1.0.5-1";

  src = fetchFromGitHub {
    owner = "aphototool";
    repo = "A-Photo-Tool-Libre";
    rev = "v${version}";
    hash = "sha256-zi4KPCBUFk9XxANBevz48KVwCUqvG167MBGhQbx/q2g=";
  };

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  postPatch = ''
    substituteInPlace src/src.pro \
      --replace "usr" "$out"
  '';

  meta = with lib; {
    description = "Easy to use photo editing software";
    homepage = "https://www.ahola.me/aphototoollibre.html";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
