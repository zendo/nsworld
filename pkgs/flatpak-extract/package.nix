{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  python3,
  ostree,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "flatpak-extract";
  version = "0-unstable-2025-04-23";

  src = fetchFromGitHub {
    owner = "faveoled";
    repo = "flatpak-extract";
    rev = "6b3d9df404b95998530de82c7a59d7a20228a5f1";
    hash = "sha256-5Sm2UsyTpRx2061wOTFooTzL3fIPK/0qJxOtZvzcwgE=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    python3
  ];

  # 关键点：在 Nix 构建沙盒中，/build 目录不支持 xattr。
  # 将 ostree 模式由 bare-user 修改为 archive 即可完美绕过该限制。
  postPatch = ''
    substituteInPlace local/flatpak-extract/flatpak-extract.py \
      --replace-fail "--mode=bare-user" "--mode=archive"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 local/flatpak-extract/flatpak-extract.py $out/bin/$pname
    # patchShebangs $out/bin/$pname
    wrapProgram $out/bin/$pname \
      --prefix PATH : ${lib.makeBinPath [ ostree ]}

    runHook postInstall
  '';

  meta = {
    description = "CLI app for extracting .flatpak files";
    homepage = "https://github.com/faveoled/flatpak-extract";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "flatpak-extract";
  };
})
