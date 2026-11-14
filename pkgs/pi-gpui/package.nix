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

  # gpui enables zed-font-kit's fontconfig dlopen feature, so fontconfig joins
  # the Vulkan loader, libGL and libwayland: nothing links against them, the
  # loader finds them only through the executable's RUNPATH.
  postFixup = ''
    patchelf --add-rpath ${
      lib.makeLibraryPath [
        (lib.getLib fontconfig)
        libglvnd
        vulkan-loader
        wayland
      ]
    } $out/bin/pi-gpui
  '';

  postInstall = ''
    install -Dm644 resources/linux/pi-gpui.desktop $out/share/applications/pi-gpui.desktop
    install -Dm644 resources/linux/pi-gpui.png $out/share/icons/hicolor/512x512/apps/pi-gpui.png
    install -Dm644 LICENSE $out/share/pi-gpui/LICENSE
    install -Dm644 assets/fonts/OFL.txt $out/share/pi-gpui/JetBrainsMono-OFL.txt
  '';

  meta = {
    description = "Native GUI for the pi coding agent, built with GPUI";
    homepage = "https://pi-gpui.dev";
    downloadPage = "https://github.com/bytesbay/pi-gpui";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "pi-gpui";
  };
})
