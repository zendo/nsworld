/*

Traceback (most recent call last):
  File "/nix/store/4d9pzzhmyr1pr6dl6i9wk1dxnvr3qh62-frog-1.1.3/bin/..frog-wrapped-wrapped", line 60, in <module>
    from frog import main
  File "/nix/store/4d9pzzhmyr1pr6dl6i9wk1dxnvr3qh62-frog-1.1.3/lib/python3.10/site-packages/frog/main.py", line 36, in <module>
    gi.require_version('Notify', '0.7')
  File "/nix/store/qbmb43cd3g4h3ijchrswf23mi40h2fxa-python3.10-pygobject-3.42.1/lib/python3.10/site-packages/gi/__init__.py", line 126, in require_version
    raise ValueError('Namespace %s not available' % namespace)
ValueError: Namespace Notify not available

*/
{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  meson,
  ninja,
  pkg-config,
  gtk3,
  glib,
  libnotify,
  gobject-introspection,
  wrapGAppsHook,
  appstream-glib,
  desktop-file-utils,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "frog";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "TenderOwl";
    repo = "Frog";
    rev = "${version}";
    sha256 = "sha256-yOjfiGJUU25zb/4WprPU59yDAMpttS3jREp1kB5mXUE=";
  };

  # setup.py and pyproject.toml not found
  format = "other";

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk3
  ];

  propagatedBuildInputs =  [
    python3.pkgs.pygobject3
    libnotify
  ];

  # pythonPath = with python3.pkgs; requiredPythonModules [ pygobject3 ];

  # postUnpack = ''
  # (
  # cd "$sourceRoot"
  # rm build-aux/meson/postinstall.py
  # )
  # '';


  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py
  '';


  # delete finnal line to stop exec postinstall.py
  # patchPhase = ''
  #   sed -i '$ d' meson.build
  # '';

  meta = with lib; {
    homepage = "https://github.com/TenderOwl/Frog";
    description = "Intuitive text extraction tool (OCR) for GNOME";
    maintainers = with maintainers; [zendo];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
