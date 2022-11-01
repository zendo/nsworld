{ lib
, fetchFromGitHub
, python3
, makeWrapper
, chntpw
}:
# WIP!!!
python3.pkgs.buildPythonApplication rec {
  pname = "bt-dualboot";
  version = "1.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "x2es";
    repo = pname;
    # rev = "v${version}";
    # https://github.com/x2es/bt-dualboot/pull/5
    rev = "6e56e34c4a6aedd4b89acd6292cfad7ff49028d4";
    hash = "sha256-kvuDiG4zkmSaFGNzjnK2zEeJtLzm+gjb92ZFSfPhiWE=";
  };

  nativeBuildInputs = [
    python3.pkgs.poetry-core
    makeWrapper
  ];

  # propagatedBuildInputs = with python3.pkgs; [
  #   wheel
  # ];

  # dontWrapPythonPrograms = true;

  preFixup = ''
    wrapProgram $out/bin/bt-dualboot \
      --prefix PATH ":" "${lib.makeBinPath [ chntpw ]}";
  '';

  meta = with lib; {
    description = "Sync Bluetooth for dualboot Linux and Windows";
    homepage = "https://github.com/x2es/bt-dualboot";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
