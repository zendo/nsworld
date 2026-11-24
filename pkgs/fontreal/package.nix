{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6,
  freetype,
  fontconfig,
  pkg-config,
  binutils,
  patchelf,
  xxd,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fontreal";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "calculatetech";
    repo = "fontreal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-svw2IhhwwGgRsOuAkBnZW5Mqq/5XDyuvqS7OBmr4JZU=";
  };

  # The providers are compiled against Qt's private rendering interfaces and
  # record the build IDs of the Qt libraries they were compiled against. Qt
  # therefore has to come from the same nixpkgs as the running Plasma session;
  # the loader refuses to hook a Qt whose build ID differs.
  nativeBuildInputs = [
    pkg-config
    binutils
    patchelf
    xxd
    qt6.qtbase
    qt6.qtshadertools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtwayland
    freetype
    fontconfig
  ];

  dontConfigure = true;
  # No application to wrap: the plugins are loaded by whatever Qt app runs.
  dontWrapQtApps = true;
  # Upstream refuses to ship a provider with RPATH/RUNPATH so that it never
  # pulls a second Qt into the process. A NixOS session already has the Qt,
  # FreeType and Fontconfig libraries loaded, so the sonames resolve anyway.
  NIX_DONT_SET_RPATH = "1";

  # qsb is not installed next to qtpaths, so the script's lookup through
  # QT_HOST_BINS cannot find it; nixpkgs installs Qt Quick in its own output
  # instead of the qtbase prefix the script assumes for every module.
  postPatch = ''
        substituteInPlace tools/build-qt-stock-helper.sh \
          --replace-fail 'qsb=$("$qtpaths" --query QT_HOST_BINS)/qsb' \
          'qsb=${qt6.qtshadertools}/bin/qsb' \
          --replace-fail 'quick="$runtime/libQt6Quick.so.6"' \
          'quick=${qt6.qtdeclarative}/lib/libQt6Quick.so.6' \
          --replace-fail 'if readelf -d "$work/$binary" | grep -E' \
          'patchelf --remove-rpath "$work/$binary"
        if readelf -d "$work/$binary" | grep -E'
        substituteInPlace tools/build-qt-stock-helper.sh \
          --replace-fail 'for module in QtCore QtGui QtQml QtQmlIntegration QtQmlModels QtQuick QtWidgets; do' \
          'for hdr in "$headers" ${qt6.qtdeclarative}/include; do
      for module in QtCore QtGui QtQml QtQmlIntegration QtQmlModels QtQuick QtWidgets; do
        [[ -d $hdr/$module ]] || continue' \
          --replace-fail '    flags+=(-I"$headers/$module" "-I$headers/$module/$qt_version" "-I$headers/$module/$qt_version/$module")
    done' \
          '    flags+=(-I"$hdr/$module" "-I$hdr/$module/$qt_version" "-I$hdr/$module/$qt_version/$module")
      done
    done'
  '';

  buildPhase = ''
    runHook preBuild
    bash tools/build-qt-stock-helper.sh build/qt-stock-helper
    runHook postBuild
  '';

  # Mirrors tools/package-qt-stock-helper.sh: copy the two providers for this
  # Qt build, then compile one small loader per plugin that picks the provider
  # matching the Qt libraries the application actually loaded.
  installPhase = ''
    runHook preInstall

    # Qt looks for generic plugins in <QT_PLUGIN_PATH entry>/generic, so the
    # path below is the parent of the generic directory.
    pluginRoot=$out/lib/fontreal/qt6/plugins
    plugins=$pluginRoot/generic
    provider=$(echo build/qt-stock-helper/*-*)
    key=$(basename "$provider")
    if [[ ! $key =~ ^([0-9a-f]{40})-([0-9a-f]{40})$ ]]; then
      echo "unexpected provider directory: $key" >&2
      exit 1
    fi
    gui_id=''${BASH_REMATCH[1]}
    quick_id=''${BASH_REMATCH[2]}

    install -D -m644 "$provider/libfontreal-cached-probe.so" \
      "$plugins/providers/$key/libfontreal-cached-probe.so"
    install -D -m644 "$provider/libfontreal_quick_default_probe.so" \
      "$plugins/providers/$key/libfontreal_quick_default_probe.so"

    work=$(mktemp -d)
    printf '    {{%s}, {%s}, "%s"},\n' \
      "$(sed -E 's/(..)/0x\1,/g' <<< "$gui_id")" \
      "$(sed -E 's/(..)/0x\1,/g' <<< "$quick_id")" "$key" > "$work/providers.inc"

    build_loader() {
      local name=$1
      shift
      local note=$work/plugin.note
      objcopy --dump-section ".note.qt.metadata=$note" \
        "$plugins/providers/$key/$name" "$work/provider-copy"
      cc -O2 -fPIC -shared -fvisibility=hidden -I "$work" \
        "-DFONTREAL_METADATA=\"$note\"" \
        "-DMETADATA_SIZE=$(stat -c %s "$note")" \
        "-DPROVIDER_FILE=\"$name\"" \
        "$@" integrations/qt-stock/loader.c integrations/qt-stock/metadata.S \
        -ldl -o "$plugins/$name"
    }
    build_loader libfontreal-cached-probe.so
    build_loader libfontreal_quick_default_probe.so -DFONTREAL_QUICK_LOADER

    # The session script only sets the variables; the plugin directory moves
    # from /usr/lib on a distro install to $out here.
    mkdir -p $out/etc/xdg/plasma-workspace/env
    substitute integrations/qt-stock/plasma-env.sh \
      $out/etc/xdg/plasma-workspace/env/fontreal.sh \
      --replace-fail /usr/lib/fontreal/qt6/plugins "$pluginRoot"

    install -D -m644 LICENSE $out/share/licenses/fontreal/LICENSE
    install -D -m644 THIRD_PARTY_NOTICES.md \
      $out/share/doc/fontreal/THIRD_PARTY_NOTICES.md

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    test -f $out/lib/fontreal/qt6/plugins/generic/libfontreal-cached-probe.so
    test -f $out/lib/fontreal/qt6/plugins/generic/libfontreal_quick_default_probe.so
    test -n "$(echo $out/lib/fontreal/qt6/plugins/generic/providers/*/libfontreal-cached-probe.so)"
    test -f $out/etc/xdg/plasma-workspace/env/fontreal.sh
    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Subpixel text rendering for stock Qt and Plasma sessions";
    longDescription = ''
      Fontreal installs Qt generic plugins that hook a compatible stock Qt 6
      build for crisp, pixel-aligned text. Point QT_PLUGIN_PATH and
      QT_QPA_GENERIC_PLUGINS at $out/lib/fontreal/qt6/plugins and the plugin
      names, as $out/etc/xdg/plasma-workspace/env/fontreal.sh does.
    '';
    homepage = "https://github.com/calculatetech/fontreal";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ ];
  };
})
