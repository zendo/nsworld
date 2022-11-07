{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "zdict";
  version = "5.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    # rev = version;
    rev = "8840e31824662b2d597af99654e0a6a098ff58ea";
    hash = "sha256-DHOO4GzHa9lz6RHFc9v4dB55k8uDcvkJduQpKxee3sA=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    peewee
    requests
    pyjokes
    gnureadline
    beautifulsoup4
  ];

  checkInputs = with python3.pkgs;[
    flake8
    pytest
    pytest-cov
    pytest-flake8
    coverage
  ];

  postPatch = ''
    sed -i '1,10d' setup.cfg

    substituteInPlace setup.py \
      --replace "gnureadline==6.3.3" "gnureadline==8.1.2"

    substituteInPlace requirements-test.txt \
      --replace "pytest-flake8==1.1.0" "pytest-flake8==1.1.1" \
      --replace "pytest-cov==4.0.0" "pytest-cov==3.0.0" \
      --replace "coverage==6.5.0" "coverage==6.4.4"

    substituteInPlace requirements-test.txt \
      --replace "flake8==4.0.1" "flake8==5.0.4" \
      --replace "pytest-flake8==1.1.0" "pytest-flake8==1.1.1"
  '';

  preConfigure = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "The last online dictionary CLI framework you need";
    homepage = "https://github.com/zdict/zdict";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ zendo ];
  };
}
