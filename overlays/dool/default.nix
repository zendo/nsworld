{ lib, fetchFromGitHub, python3, installShellFiles  }:

python3.pkgs.buildPythonApplication rec {
  pname = "dool";
  version = "1.1.0";

  format = "other";

  src = fetchFromGitHub {
    owner = "scottchiefbaker";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2J/5T/2rbdO+5lpi6WcuPd1kGIKYw/yqoHf8g6koGI8=";
  };

  nativeBuildInputs = [ installShellFiles ];

  dontBuild = true;

  postPatch = ''
    chmod +x install.py
    patchShebangs install.py
    substituteInPlace dool --replace \
      "/usr/share/dool/" "$out/share/dool/plugins/"
   '';

  installPhase = ''
    export HOME=$out
    ./install.py

    mkdir -p $out/share/dool
    cp -r plugins "$out/share/dool/"
    installManPage docs/dool.1
  '';

  meta = with lib; {
    description = "Python3 compatible clone of dstat ";
    homepage = "https://github.com/scottchiefbaker/dool";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
