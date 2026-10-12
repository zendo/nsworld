{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rclone-browser-ng";
  version = "2.0.2";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "SysAdminDoc";
    repo = "RcloneBrowserNG";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nVkboL3z99a7o5MEBqJCgNqePVbzciTeXTjAvmPOOsY=";
  };

  # https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=rclone-browser-ng
  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail \
        '-pedantic -Wall -Wextra -Werror -Wno-deprecated-declarations' \
        '-pedantic -Wall -Wextra -Wno-deprecated-declarations'
  '';

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    # qt6.qtsvg
  ];

  meta = {
    description = "Modern rclone GUI — file browser, transfer manager, mount handler";
    homepage = "https://github.com/SysAdminDoc/RcloneBrowserNG";
    changelog = "https://github.com/SysAdminDoc/RcloneBrowserNG/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "rclone-browser-ng";
  };
})
