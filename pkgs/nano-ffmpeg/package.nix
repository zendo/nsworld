{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  ffmpeg,
}:

buildGoModule (finalAttrs: {
  pname = "nano-ffmpeg";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "dgr8akki";
    repo = "nano-ffmpeg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G5e+dAdissGB8ZMT5RTrXGfk6SWNDVOj+EH/+DWGXTs=";
  };

  vendorHash = "sha256-irJksXupZGHzZ5vbFeI9laKi5+LyATc1lMxpMLLl69w=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/dgr8akki/nano-ffmpeg/cmd.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ makeWrapper ];

  preFixup = ''
    wrapProgram $out/bin/nano-ffmpeg \
      --prefix PATH ":" "${lib.makeBinPath [ ffmpeg ]}";
  '';

  meta = {
    description = "Wraps the full power of ffmpeg in a beautiful, keyboard-driven terminal dashboard";
    homepage = "https://nano-ffmpeg.vercel.app";
    downloadPage = "https://github.com/dgr8akki/nano-ffmpeg";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "nano-ffmpeg";
  };
})
