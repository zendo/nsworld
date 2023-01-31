{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "konsave";
  version = "2.2.0";
  format = "setuptools";

  src = python3.pkgs.fetchPypi {
    inherit version;
    pname = "Konsave";
    hash = "sha256-tWarqT2jFgCuSsa2NwMHRaR3/wj0khiRHidvRNMwM8M=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pyyaml
    setuptools
  ];

  preConfigure = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Save Linux Customization";
    maintainers = with maintainers; [ MoritzBoehme ];
    homepage = "https://github.com/Prayag2/konsave";
    license = licenses.gpl3;
  };
}
