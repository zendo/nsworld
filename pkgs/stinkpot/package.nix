{
  lib,
  fetchgit,
  buildGoModule,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "stinkpot";
  version = "0.1.0";
  __structuredAttrs = true;

  src = fetchgit {
    url = "https://tangled.org/oppi.li/stinkpot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-grsoctCXQf7uzf6jmPQpfT+O7imnLQIp66/tPMeT3dY=";
  };

  vendorHash = "sha256-IVPACl1oWnBKGzcXvG5gzev8MwhzIKNI7zwEKJjhFc8=";

  env.CGO_ENABLED = "0";

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "sqlite-backed shell history";
    homepage = "https://tangled.org/oppi.li/stinkpot";
    license = lib.licenses.mit;
    mainProgram = "stinkpot";
    maintainers = [ lib.maintainers.supermarin ];
  };
})
