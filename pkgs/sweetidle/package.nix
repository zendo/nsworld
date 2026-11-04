{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  wayland,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sweetidle";
  version = "0.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sweetwm";
    repo = "sweetidle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LDp6q3ydQk6G8Llc5zGKsnce2XsUi+r2ucD9uf3D8B0=";
  };

  cargoHash = "sha256-m6fb9t93Q6xwKvTW0FNzCqAgDD/427dJ4weM3VilSrs=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight and powerful idle daemon for Wayland compositors";
    homepage = "https://github.com/sweetwm/sweetidle";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "sweetidle";
  };
})
