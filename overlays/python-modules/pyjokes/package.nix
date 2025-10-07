{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytest,
}:

buildPythonPackage rec {
  pname = "pyjokes";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-CIYO7beMv6RhgkPI2wiPIcOYI+zh/a8BM+UtnFbpgaU=";
  };

  pyproject = true;

  pythonImportsCheck = [ "pyjokes" ];

  build-system = [ setuptools ];

  meta = {
    description = "One line jokes for programmers (jokes as a service)";
    homepage = "https://pyjok.es/";
    license = lib.licenses.bsd3;
  };
}
