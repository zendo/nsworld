{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tanim";
  version = "0-unstable-2026-09-29";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "SantiagoSchez";
    repo = "tanim";
    rev = "a446fc509ee46f5527858f1abaa632e30859a947";
    hash = "sha256-N2nNj4B8lbMpxt4Dy0iRqjiQOXg8sjOFQQ1sTBNIXic=";
  };

  cargoHash = "sha256-vImVs1zkVKmrqKFZU0XkaOMOwdJ3gCJLL3R+10+ah28=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Endless, procedural screensaver animations for your terminal";
    homepage = "https://github.com/SantiagoSchez/tanim";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "tanim";
  };
})
