{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lsq";
  version = "0.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "AlexDevFlow";
    repo = "lsq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F2EeyCStZ0DhksTRnJh3WsDJnqr3oEAsYzGtDgxFnQ8=";
  };

  cargoHash = "sha256-enV1NpXawqD/jkdSjlIe5TvuyDQnotE2JIusBwvj8k8=";

  meta = {
    description = "Command-line client for LocalSend";
    homepage = "https://github.com/AlexDevFlow/lsq";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "lsq";
  };
})
