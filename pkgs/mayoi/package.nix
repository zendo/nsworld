{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  fetchurl,
  go,
  makeWrapper,
  gtk3,
  glib,
  gdk-pixbuf,
  cairo,
  pango,
  atk,
  libepoxy,
  libGL,
  webkitgtk_4_1,
  libsoup_3,
  fontconfig,
  harfbuzz,
  libsecret,
  nix-update-script,
}:

let
  runtimeLibs = [
    gtk3
    glib
    gdk-pixbuf
    cairo
    pango
    atk
    libepoxy
    libGL
    webkitgtk_4_1
    libsoup_3
    fontconfig
    harfbuzz
    libsecret
  ];

  # The libghostty-vt this pinned MyGo binds: the build CLI copies it into
  # the app's resources, but it has to be in the cache because the Nix
  # sandbox has no network.
  ghosttyVt =
    if go.GOARCH == "amd64" then
      fetchurl {
        url = "https://github.com/sorrycc/mygo/releases/download/libghostty-vt-9cd19b40de63/libghostty-vt-linux-amd64.so";
        hash = "sha256-sDciJTyhZkZllUwMMNLC+fDUMfsgdCJYqSlZJ/oA7HQ=";
      }
    else if go.GOARCH == "arm64" then
      fetchurl {
        url = "https://github.com/sorrycc/mygo/releases/download/libghostty-vt-9cd19b40de63/libghostty-vt-linux-arm64.so";
        hash = "sha256-lamRp48gDd1KrnmMQw8I0xIq7dmRvezbGQxLvGb0RrQ=";
      }
    else
      throw "Mayoi: no libghostty-vt build for linux/${go.GOARCH}";
  ghosttySha =
    {
      amd64 = "b03722253ca1664665954c0c30d2c2f9f0d431fb20742258a9295927fa00ec74";
      arm64 = "95a991a78f200ddd4aae798c430f08d3122aedd991bdecdb190c4bbc66f446b4";
    }
    .${go.GOARCH};

in
buildGo127Module (finalAttrs: {
  pname = "mayoi";
  version = "0.18.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sorrycc";
    repo = "Mayoi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nAQQwNMvw4A1/bHF1KV0q+/HiI79ey6i4j4A8e8E6so=";
  };

  vendorHash = "sha256-vDt22hyHn/g9gfv4DV7EY3kM02rjfn72cUcFGvU3PFA=";

  nativeBuildInputs = [ makeWrapper ];

  preBuild = ''
    export HOME="$TMPDIR/home"
    export XDG_CACHE_HOME="$TMPDIR/cache"
    mkdir -p "$HOME" "$XDG_CACHE_HOME/mygo/natives/${ghosttySha}"
    cp ${ghosttyVt} "$XDG_CACHE_HOME/mygo/natives/${ghosttySha}/libghostty-vt.so"
  '';

  buildPhase = ''
    runHook preBuild

    go tool mygo build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 build/linux-${go.GOARCH}/mayoi "$out/bin/mayoi"
    install -Dm755 build/linux-${go.GOARCH}/libghostty-vt.so "$out/bin/libghostty-vt.so"
    install -Dm644 build/linux-${go.GOARCH}/mayoi.png "$out/share/icons/hicolor/512x512/apps/mayoi.png"
    install -Dm644 build/linux-${go.GOARCH}/mayoi.desktop "$out/share/applications/mayoi.desktop"

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram "$out/bin/mayoi" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"
  '';

  # No buildInputs or wrapGAppsHook3: MyGo links nothing and loads GTK,
  # WebKitGTK and the rest through purego at run time. The wrapper only
  # supplies their directories.
  # Upstream's tests are UI tests: they measure rendered text, start
  # terminals, use SSH and Git, and open local sockets. They depend on the
  # host's fonts and a writable session and fail in the Nix build sandbox
  # (layout assertions, localhost/network, and native terminal libraries).
  # Run `go test` in a real desktop session instead.
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A small, fast code editor written in Go";
    homepage = "https://github.com/sorrycc/Mayoi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "mayoi";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
