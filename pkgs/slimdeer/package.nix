{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "slimdeer";
  version = "0.3.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "heydeer";
    repo = "slimdeer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QsefUMBMuVgkuBbQPu/UxNekTdQWcDBVH8+E8jAhax4=";
  };

  cargoHash = "sha256-5wt05cc4FtAbxWIFVGye5jc+j36lzbxbR/k8E+skOJI=";

  # The vendored libaom sources define _GNU_SOURCE themselves, but slimdeer's
  # build.rs force-includes slimdeer_clib.h (which pulls in glibc headers)
  # before every C file, so that definition comes too late to expose
  # pthread_setname_np. Define it for the whole build instead.
  env.NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Smaller images, same picture";
    homepage = "https://github.com/heydeer/slimdeer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "slimdeer";
  };
})
