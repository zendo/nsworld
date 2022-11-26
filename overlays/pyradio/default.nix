{ lib
, python3
, fetchFromGitHub
, installShellFiles
, makeWrapper
, libnotify
, mpv
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pyradio";
  version = "0.8.9.31";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "coderholic";
    repo = pname;
    rev = version;
    hash = "sha256-9Fc42f0plduihXDDLXWBdt62maxDJ0cwumIvbiMcrGc=";
  };

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  propagatedBuildInputs = with python3.pkgs; [
    requests
    psutil
    dnspython
  ];

  pythonImportsCheck = [ "pyradio" ];

  checkPhase = ''
    $out/bin/pyradio --help
  '';

  postPatch = ''
    sed -i 's/distro = None/distro = NixOS/' pyradio/config

    # disable topbar msg
    substituteInPlace pyradio/radio.py \
      --replace 'rightStr = " https://github.com/coderholic/pyradio"' 'rightStr = ""'
    # TODO Notifications
    # substituteInPlace pyradio/config.py \
    #   --replace "notify-send" "${libnotify}/bin/notify-send"
  '';

  postInstall = ''
    installManPage *.1
    install -Dm 444 devel/pyradio.desktop -t $out/share/applications
    install -Dm 444 devel/pyradio.png -t $out/share/icons/hicolor/512x512/apps

    wrapProgram $out/bin/${pname} \
      --prefix PATH ":" "${lib.makeBinPath [ mpv ]}";
  '';

  meta = with lib; {
    homepage = "http://www.coderholic.com/pyradio/";
    description = "Curses based internet radio player";
    license = licenses.mit;
    maintainers = with maintainers; [ contrun ];
  };
}
