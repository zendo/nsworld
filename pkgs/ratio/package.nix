{
  lib,
  fetchFromCodeberg,
  python3Packages,
  wrapGAppsHook4,
  gobject-introspection,
  gtk4,
  libadwaita,
  fontconfig,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ratio";
  version = "1.0.7";
  __structuredAttrs = true;

  # upstream ships no tags or releases; the version is the one advertised in
  # the metainfo file, so the commit is pinned instead of a tag
  src = fetchFromCodeberg {
    owner = "markwyner";
    repo = "ratio-for-linux";
    rev = "b3fe2a49a6ecc660d2a7b291608d1f7e550e3fd5";
    hash = "sha256-S2DQoIIs7p37cZUPLH4MM/ohiDDOafnQH2tG5I+yfms=";
  };

  pyproject = false;

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  dependencies = [ python3Packages.pygobject3 ];

  dontBuild = true;

  # front.py dlopens libfontconfig to register the bundled Inter font
  makeWrapperArgs = [
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    "${lib.getLib fontconfig}/lib"
  ];

  # there is no setup.py/pyproject, so lay the files out like upstream's Makefile
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/ratio
    cp -r ratio.py window.py contrast.py ui fonts icons $out/share/ratio/

    install -Dm644 flatpak/com.markwyner.ratio.desktop \
      $out/share/applications/com.markwyner.ratio.desktop
    install -Dm644 flatpak/com.markwyner.ratio.metainfo.xml \
      $out/share/metainfo/com.markwyner.ratio.metainfo.xml
    mkdir -p $out/share/icons
    cp -r icons/hicolor $out/share/icons/

    # ratio.py resolves its icons and fonts relative to its own directory, so
    # the entry point only has to put share/ratio on sys.path
    mkdir -p $out/bin
    cat > $out/bin/ratio <<'EOF'
    #!/usr/bin/env python3
    import os
    import sys

    _prefix = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    sys.path.insert(0, os.path.join(_prefix, "share", "ratio"))

    from ratio import main

    main()
    EOF
    chmod 755 $out/bin/ratio

    runHook postInstall
  '';

  meta = {
    description = "WCAG color-contrast checker for text, non-text and focus appearance";
    homepage = "https://codeberg.org/markwyner/ratio-for-linux";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "ratio";
    platforms = lib.platforms.linux;
  };
})
