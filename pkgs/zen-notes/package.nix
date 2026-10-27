{
  lib,
  buildGoModule,
  fetchFromGitHub,
  esbuild,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "zen";
  version = "2.0.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sheshbabu";
    repo = "zen";
    tag = finalAttrs.version;
    hash = "sha256-pZmWwhrGZEx+NyNwS3N9ng1onX7duc6Y5eitw9Fw4xc=";
  };

  vendorHash = "sha256-LuFJ/qLEr+X9Wb6dnSSdo9h73rrve4GGoi4ousEu0PM=";

  ldflags = [ "-s" ];

  tags = [ "fts5" ];

  env.CGO_ENABLED = "1";

  nativeBuildInputs = [ esbuild ];

  preBuild = ''
    esbuild index.js \
      --bundle \
      --minify \
      --format=esm \
      --outfile=assets/bundle.js \
      --loader:.js=jsx \
      --jsx-factory=h \
      --jsx-fragment=Fragment
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Selfhosted notes app";
    homepage = "https://github.com/sheshbabu/zen";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "zen";
  };
})
