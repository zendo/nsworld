{
  lib,
  python3,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "konsave";
  version = "2.1.1";

  src = python3.pkgs.fetchPypi {
    inherit version;
    pname = "Konsave";
    sha256 = "sha256-04nlFhU8nFxcHht2SKOvRyA+6cYzqNxZlvU+pRX0ynA=";
  };

  nativeBuildInputs = with python3.pkgs; [setuptools-scm];

  # Specify runtime dependencies for the package
  propagatedBuildInputs = with python3.pkgs; [
    pyyaml
    # pkgs/development/embedded/fpga/apio/default.nix
    setuptools # needs pkg_resources at runtime (technically not needed when tinyprog is also in this list because of the propagatedBuildInputs of tinyprog)
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
    --replace 'PyYaml==5.4.1' 'PyYaml'
  '';

  doCheck = false;

  meta = with lib; {
    mainainers = with maintainers; [MoritzBoehme];
    homepage = "https://github.com/Prayag2/konsave";
    license = licenses.gpl3;
  };
}
