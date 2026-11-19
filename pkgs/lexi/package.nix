{
  lib,
  buildGoModule,
  fetchFromGitHub,
  templ,
  tailwindcss_4,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "lexi";
  version = "unstable-2026-07-21";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lexihq";
    repo = "lexi";
    rev = "de9c501a2bb9d1ee53b4f8475c0d39df3509bfe1";
    hash = "sha256-WW9SrTg4Jh9f1swroIx5p+d0hQY4fpGBVn3xGkpR41E=";
  };

  vendorHash = "sha256-mSctJSFRqTc4k1cs8L3p74F3J59024y+YNURa1ngvCg=";

  subPackages = [ "cmd/lexi" ];

  nativeBuildInputs = [
    templ
    tailwindcss_4
  ];

  env.CGO_ENABLED = "0";

  # The templates and the embedded stylesheet are build artifacts, not sources.
  preBuild = ''
    templ generate
    tailwindcss -i internal/ui/input.css -o static/css/app.css --minify
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Web UI for managing Incus LXC containers";
    homepage = "https://github.com/lexihq/lexi";
    license = lib.licenses.unfreeRedistributable;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "lexi";
  };
})
