{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule {
  pname = "go-translation";
  version = "unstable-2022-05-02";

  src = fetchFromGitHub {
    owner = "fedeztk";
    repo = "got";
    rev = "4c1a9d5e3d45e06ab83f9c7bf0c7c435d7d8593e";
    sha256 = "sha256-qdXqy5nBPYjtfHkPYp04dvFpYs/Zh2gtUKuByy6dEC0=";
  };

  vendorSha256 = "sha256-mXK11uHbjrb43wCm4pA5S4tj3LrR9OkA9l7jgtsB2J0=";

  # subPackages = [ "." ];

  doCheck = false;

  meta = with lib; {
    description = "Translating TUI written in go using simplytranslate's API";
    homepage = "https://github.com/fedeztk/got";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
