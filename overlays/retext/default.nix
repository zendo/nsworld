{ lib
, python3
, fetchzip
, fetchurl
, fetchFromGitHub
, wrapQtAppsHook
, glib
, gtk3
,  gobject-introspection
  , hicolor-icon-theme
, desktop-file-utils
, buildEnv
, aspellDicts
  # Use `lib.collect lib.isDerivation aspellDicts;` to make all dictionaries
  # available.
, enchantAspellDicts ? with aspellDicts; [ en en-computers en-science ]
}:

let
  toolbarIcons = fetchzip {
    url = "https://github.com/retext-project/retext/archive/icons.zip";
    hash = "sha256-LQtSFCGWcKvXis9pFDmPqAMd1m6QieHQiz2yykeTdnI=";
    # stripRoot=false;
  };
in
python3.pkgs.buildPythonApplication rec {
  pname = "retext";
  version = "8.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "retext-project";
    repo = pname;
    rev = version;
    hash = "sha256-22yqNwIehgTfeElqhN5Jzye7LbcAiseTeoMgenpmsL0=";
  };

  nativeBuildInputs = [
    wrapQtAppsHook
    # desktop-file-utils
    # gobject-introspection
  ];

  # buildInputs = [
  #   # gtk3
  #   # hicolor-icon-theme
  #   # # glib
  #   # gtk3
  # ];

  propagatedBuildInputs = with python3.pkgs; [
    requests
    chardet
    docutils
    markdown
    markups
    pyenchant
    pygments
    pyqt6
  ];

  patches = [ ./remove-wheel-check.patch ];

  # postPatch = ''
  #   substituteInPlace setup.py \
  #     --replace "icons_tgz = 'https://github.com/retext-project/retext/archive/icons.tar.gz'" \
  #       "icons_tgz = '${toolbarIcons}'"
  # '';

  # prevent double wrapping
  dontWrapQtApps = true;

  postInstall = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    makeWrapperArgs+=(
      "--set" "ASPELL_CONF" "dict-dir ${buildEnv {
        name = "aspell-all-dicts";
        paths = map (path: "${path}/lib/aspell") enchantAspellDicts;
      }}"
    )

    # mkdir -p $out/share/retext/icons
    # install -Dm444 ${toolbarIcons}/* -t $out/share/retext

    substituteInPlace $out/share/applications/me.mitya57.ReText.desktop \
      --replace "Exec=ReText-${version}.data/scripts/retext %F" "Exec=$out/bin/retext %F" \
      --replace "Icon=ReText/icons/retext.svg" "Icon=retext"
  '';

  doCheck = false;

  pythonImportsCheck = [
    "ReText"
  ];

  meta = with lib; {
    description = "Editor for Markdown and reStructuredText";
    homepage = "https://github.com/retext-project/retext/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ klntsky ];
    platforms = platforms.unix;
  };
}
