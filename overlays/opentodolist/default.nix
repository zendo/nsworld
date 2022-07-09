# wip
{ lib
, stdenv
, fetchFromGitLab
, wrapQtAppsHook
, extra-cmake-modules
, cmake
  
# , kio
# , ki18n
# , kxmlgui
# , kconfig
# , karchive
# , kcoreaddons
# , kconfigwidgets
# , nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "opentodolist";
  version = "3.41.1";

  src = fetchFromGitLab {
    owner = "rpdev";
    repo = pname;
    rev = version;
    sha256 = "sha256-ykXixCzbZ4xYgvwqqpltO7WsazxbOCSihGKj0lqxvqo=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
    # extra-cmake-modules
    # wrapQtAppsHook
  ];

  buildInputs = [
    # kio
    # ki18n
    # kxmlgui
    # kconfig
    # karchive
    # kcoreaddons
    # kconfigwidgets
  ];

  # passthru.updateScript = nix-update-script {
  #   attrPath = pname;
  # };

  meta = with lib; {
    description = "A todo and task managing application, written in Qt and using QML for its UI";
    homepage = "https://gitlab.com/rpdev/opentodolist";
    changelog = "https://github.com/g-fb/mangareader/releases/tag/${src.rev}";
    platforms = platforms.linux;
    license = with licenses; [ gpl3Plus cc-by-nc-sa-40 ];
    maintainers = with maintainers; [ zendo ];
  };
}
