{ lib
, buildPythonApplication
, fetchPypi
, pythonOlder
, pyspellchecker
}:

buildPythonApplication rec {
  pname = "wordle-aid";
  version = "2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZknQC7TU3kVfx2tlfNPkHWiyFR2i3dFzfuXrRuA65UQ=";
  };

  propagatedBuildInputs = [ pyspellchecker ];

  meta = with lib; {
    description = "CLI program to filter word choices to aid solving Wordle game problems";
    homepage = "https://github.com/bulletmark/wordle-aid";
    license =  licenses.gpl3Plus;
    maintainers = with maintainers; [ zendo ];
  };
}
