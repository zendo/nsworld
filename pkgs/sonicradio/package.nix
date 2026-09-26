{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
}:

buildGoModule (finalAttrs: {
  pname = "sonicradio";
  version = "0.8.14";

  src = fetchFromGitHub {
    owner = "dancnb";
    repo = "sonicradio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ly7ipWguwE1X7F73iUbLbbgdM56Nco6is8koKHH/cfY=";
  };

  vendorHash = "sha256-iaRs3YESYRu4BQhnPJQXAU1xw1lEpY5Kf2U9KRIodNw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ alsa-lib ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  # Tests require music player binaries and networking
  doCheck = false;

  meta = {
    description = "TUI radio player making use of Radio Browser API and Bubbletea";
    homepage = "https://github.com/dancnb/sonicradio";
    changelog = "https://github.com/dancnb/sonicradio/releases/tag/v${finalAttrs.version}";
    mainProgram = "sonicradio";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alexandrutocar ];
  };
})
