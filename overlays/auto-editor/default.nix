{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "auto-editor";
  version = "22.43.1";
  format = "setuptools";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-NWuQlm13mrbqpR7Xx9wkaOBAbxb0nQgHgTK+n5g8F4k=";
  };

  # nativeBuildInputs = with python3.pkgs; [
  #   setuptools-scm
  # ];

  propagatedBuildInputs = with python3.pkgs; [
    # pyyaml
    setuptools
    av
    pillow
  ];

  # preConfigure = ''
  #   export HOME=$(mktemp -d)
  # '';

  meta = with lib; {
    description = "A command line application for automatically editing video and audio";
    homepage = "https://github.com/WyattBlue/auto-editor";
    # license = licenses.unlic;
    maintainers = with maintainers; [ zendo ];
  };
}
