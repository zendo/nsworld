{ lib
, fetchFromGitHub
, python3
, libxcb
, libXinerama
, qt5
, opencv
}:
# wip
python3.pkgs.buildPythonApplication rec {
  pname = "novelwriter";
  version = "1.6.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "vkbo";
    repo = "novelWriter";
    rev = "v${version}";
    hash = "sha256-KsFTA8nTGOqviobY7a8Cw5Ib/VSfo2mqrG7Byit8p0Q=";
  };

  # nativeBuildInputs = [
  #   # qt5.qttools
  #   # qt5.wrapQtAppsHook
  #   python3.pkgs.setuptools
  # ];

  buildInputs = [
    # opencv
    # libxcb
    libXinerama
  #   qt5.qtbase
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pyqt5
    pyenchant
    lxml
    setuptools
  ];

  # checkInputs = with python3.pkgs; [
  #   vcrpy
  #   pytestCheckHook
  # ];

  # disabledTests = [
  #   # Test requires a YouTube API key
  #   "test_get_default_config"
  # ];

  # disabledTestPaths = [
  #   # Disable tests which interact with Youtube
  #   "tests/test_api.py"
  #   "tests/test_backend.py"
  #   "tests/test_youtube.py"
  # ];

  # pythonImportsCheck = [
  #   "mopidy_youtube"
  # ];

  meta = with lib; {
    description = "Mopidy extension for playing music from YouTube";
    homepage = "https://novelwriter.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ spwhitt ];
  };
}
