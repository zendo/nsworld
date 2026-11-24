{
  lib,
  bashInteractive,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flyline";
  version = "1.11.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "HalFrgrd";
    repo = "flyline";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZK8qhsQ6FFCzGSQ/eaT/l3zSYe2UP/v/bmv8zPNwgTs=";
  };

  cargoHash = "sha256-HP03rAvGZDEQIWKGOtOdGISbU6LNJhI3eyE2GzYFcW8=";

  # gcc defaults to gnu2, which stamps a GLIBC_ABI_GNU2_TLS need on the library;
  # bash dlopen()s it against the host libc, so 2.41-only TLS breaks elsewhere.
  env = lib.optionalAttrs (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) {
    NIX_CFLAGS_COMPILE = "-mtls-dialect=gnu";
  };

  nativeCheckInputs = [ bashInteractive ];

  # The integration tests need docker.
  checkFlags = [
    "--skip"
    "test_bash"
  ];

  # The build proves nothing about loading: bash has to accept the builtin.
  postCheck = ''
    library="$(find target -type f -name 'libflyline${stdenv.hostPlatform.extensions.sharedLibrary}' -print -quit)"
    test -n "$library"
    ${bashInteractive}/bin/bash --noprofile --norc -i -c 'enable -f "$1" flyline' flyline-nix-check "$library"

    if grep -qa GLIBC_ABI_GNU2_TLS "$library"; then
      echo "libflyline needs GLIBC_ABI_GNU2_TLS; it will not load into a bash on glibc < 2.41" >&2
      exit 1
    fi
  '';

  meta = {
    description = "Bash plugin to replace readline for a modern line editing experience";
    longDescription = ''
      Flyline is a Bash loadable builtin (a dynamic library dlopen()ed by Bash)
      that adds a rich line editor: inline suggestions, fuzzy tab completion,
      configurable keybindings and prompts. Enable it in an interactive shell
      with `enable -f ''${pkgs.flyline}/lib/libflyline.so flyline`.
    '';
    homepage = "https://github.com/HalFrgrd/flyline";
    changelog = "https://github.com/HalFrgrd/flyline/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      gpl3Only
      mit
    ];
    maintainers = with lib.maintainers; [ zendo ];
    platforms = lib.platforms.unix;
  };
})
