{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  runCommandLocal,
  makeWrapper,
  cairo,
  fontconfig,
  glib,
  libxcb,
  pango,
  vulkan-loader,
  xcb-util-cursor,
  nix-update-script,
}:

let
  # motty's go.mod replaces github.com/vivaui/viva with ../viva, so the
  # framework has to be unpacked beside the source. Upstream pins nothing:
  # every release builds against vivaui/viva main as it stands that day.
  viva = fetchFromGitHub {
    owner = "vivaui";
    repo = "viva";
    rev = "9f2eb0f905108ba5b5380fd9e719eb0187167dc5";
    hash = "sha256-eBT8DSZvtPCEsBmRUSxaKxXxr+6vcn+toT6MOfDvk4s=";
  };

  mottySrc = fetchFromGitHub {
    owner = "t8y2";
    repo = "motty";
    tag = "v0.4.39";
    hash = "sha256-C5Otmw6MuiuNgB1TqkBCfN+wtrRmu8dbJ0C79v6NB78=";
  };

  # A directory source is copied into the build tree under its name, with the
  # store hash stripped (stdenv's unpackDir), so both halves have to land in
  # one derivation.
  tree = "motty-src";

  src = runCommandLocal tree { } ''
    mkdir -p $out
    cp -r ${mottySrc} $out/motty
    cp -r ${viva} $out/viva
  '';

  # Viva draws through XCB and links nothing at build time: XCB, Vulkan, Cairo
  # and Pango are opened with purego at run time, so the wrapper only has to
  # put them where dlopen looks.
  runtimeLibs = [
    cairo
    fontconfig
    glib
    libxcb
    pango
    vulkan-loader
    xcb-util-cursor
  ];
in
buildGo126Module (finalAttrs: {
  pname = "motty";
  version = "0.4.39";

  inherit src;

  # The tree holds motty beside viva; the replace directive is resolved
  # relative to the module root, so the build runs from the motty half.
  sourceRoot = tree;
  modRoot = "motty";

  vendorHash = "sha256-UbVAMrOT5BFwTwE4yfU98nyk26xLYjmVTSpApJAJYP8=";

  # third_party/golang.org/x/crypto is a module of its own (replaced into the
  # build), and `./...` would try to install packages out of it.
  subPackages = [ "cmd/motty" ];

  nativeBuildInputs = [ makeWrapper ];

  # Upstream's suite drives real windows, terminals and remote hosts; it needs
  # a display and a session, so it is not run in the sandbox.
  doCheck = false;

  postInstall = ''
    install -Dm644 assets/icon.png \
      "$out/share/icons/hicolor/1024x1024/apps/motty.png"

    install -Dm644 ${./motty.desktop} "$out/share/applications/motty.desktop"
    substituteInPlace "$out/share/applications/motty.desktop" \
      --replace-fail "@out@" "$out"

    wrapProgram "$out/bin/motty" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Desktop SSH client with terminal, SFTP, port forwarding and an AI assistant";
    homepage = "https://motty.page/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "motty";
    platforms = lib.platforms.linux;
  };
})
