{
  lib,
  python3Packages,
  fetchFromGitHub
}:
python3Packages.buildPythonApplication rec {
  pname = "konsave";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "Prayag2";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-u0cIPEfzu9OqhVK0lzEY2RDKD4sWOIbTnrXycaVANRA=";
  };

  nativeBuildInputs = with python3Packages; [setuptools-scm];
  SETUPTOOLS_SCM_PRETEND_VERSION = "v${version}";

  # Specify runtime dependencies for the package
  propagatedBuildInputs = with python3Packages; [pyyaml];

  postPatch = ''
    substituteInPlace requirements.txt \
    --replace 'PyYaml==5.4.1' 'PyYaml'
  '';

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/Prayag2/konsave";
    description = "Konsave lets use save your Linux customization and restore them very easily!";
    license = licenses.gpl3;
    maintainers = with maintainers; [zendo];
  };
}
