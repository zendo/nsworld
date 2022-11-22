{ lib, python3, fetchFromGitHub }:

python3.pkgs.buildPythonApplication rec {
  pname = "calcure";
  version = "2.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "anufrievroman";
    repo = pname;
    rev = version;
    hash = "sha256-O5oyomFIupPYVZCrtw05ycegTxIKLpcxdjkuYpcr9+8=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    jdatetime
    holidays
  ];

  meta = with lib; {
    description = "Modern TUI calendar and task manager";
    homepage = "https://github.com/anufrievroman/calcure";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
