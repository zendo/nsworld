{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vib";
  version = "0.1.0-beta.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ayanchavand";
    repo = "vib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6FBzGbV8X08jtoWf0L/pZtpW5byNIKQSKZbToW3TS0A=";
  };

  cargoHash = "sha256-0v+4dyYBHSnqoByC2Ok7ZVgVIV/1EBfFB2DzC4xeoKY=";

  doCheck = false;

  meta = {
    description = "Sleek terminal file browser with LocalSend built in";
    homepage = "https://github.com/ayanchavand/vib";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "vib";
  };
})
