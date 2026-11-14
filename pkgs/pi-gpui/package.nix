{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  fontconfig,
  freetype,
  libglvnd,
  libxcb,
  libxkbcommon,
  vulkan-loader,
  versionCheckHook,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pi-gpui";
  version = "0.2.3";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "bytesbay";
    repo = "pi-gpui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2dZmxgwqgb9yZqSOU7WdI2AbpMyr+I52E748IzPs8U4=";
  };

  cargoHash = "sha256-14yXkd8Rmfy0Z417b0UkNkZwDvPib3QdgTBg5wxxDMc=";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    fontconfig
    freetype
    libxcb
    libxkbcommon
    wayland
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  # The Vulkan loader, libGL/libEGL and libwayland are opened with dlopen: the
  # executable's RUNPATH is what the loader consults for them, so the rpath has
  # to name them even though nothing links against them.
  postFixup = ''
    patchelf --add-rpath ${
      lib.makeLibraryPath [
        libglvnd
        vulkan-loader
        wayland
      ]
    } $out/bin/pi-gpui
  '';

  postInstall = ''
    install -Dm644 resources/linux/pi-gpui.desktop $out/share/applications/pi-gpui.desktop
    install -Dm644 resources/linux/pi-gpui.png \
      $out/share/icons/hicolor/512x512/apps/pi-gpui.png
    # The app embeds the JetBrains Mono fonts; ship the licenses beside it as the
    # upstream tarball does.
    install -Dm644 LICENSE $out/share/pi-gpui/LICENSE
    install -Dm644 assets/fonts/OFL.txt $out/share/pi-gpui/JetBrainsMono-OFL.txt
  '';

  meta = {
    description = "Native GUI for the pi coding agent, built with GPUI";
    homepage = "https://github.com/bytesbay/pi-gpui";
    downloadPage = "https://pi-gpui.dev";
    license = lib.licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "pi-gpui";
  };
})
