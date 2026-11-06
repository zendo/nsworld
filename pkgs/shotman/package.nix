{
  lib,
  fetchFromSourcehut,
  rustPlatform,
  pkg-config,
  libxkbcommon,
  makeWrapper,
  slurp,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shotman";
  version = "0.5.1";

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = "shotman";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NIIMkpjtvtcxekFhNjkxkz3e5XR4z0nEbM0M+oKwTTY=";
  };

  cargoHash = "sha256-+PpNf79yz5e5Mr6HAqE9Wg/0S8JO4rWrMT7JtQYAWPs=";

  env.SHOTMAN_VERSION = "v${finalAttrs.version}";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [ libxkbcommon ];

  preFixup = ''
    wrapProgram $out/bin/shotman \
      --prefix PATH ":" "${lib.makeBinPath [ slurp ]}";
  '';

  meta = {
    description = "Uncompromising screenshot GUI for Wayland compositors";
    homepage = "https://git.sr.ht/~whynothugo/shotman";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      zendo
      fpletz
    ];
  };
})
