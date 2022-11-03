{ lib
, buildPythonPackage
, fetchPypi
, pytest
, flit-core
, requests
, tomli
}:

buildPythonPackage rec {
  pname = "wn";
  version = "0.9.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TghCKPKLxRTpvojmZi8tPGmU/D2W+weZl64PArAwDCE=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ requests tomli ];

  checkInputs = [ pytest ];

  checkPhase = ''
    export HOME=$(mktemp -d)
    pytest
  '';

  pythonImportsCheck = [ "wn" ];

  meta = with lib; {
    description = "A modern, interlingual wordnet interface for Python";
    homepage = "https://github.com/goodmami/wn";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
