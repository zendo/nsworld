{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  ffmpeg-headless,
}:

buildGoModule (finalAttrs: {
  pname = "nano-ffmpeg";
  version = "0.5.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dgr8akki";
    repo = "nano-ffmpeg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4uZ2y+Qe4uMrnpzl8BHQEWFNkhwNBBwoxb5RMnLyGfM=";
  };

  vendorHash = "sha256-AZzpINOagTfFPYOavp15oJD/LTlDoX4NfDA0DYV39NM=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/dgr8akki/nano-ffmpeg/cmd.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/${finalAttrs.meta.mainProgram} \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg-headless ]};
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
