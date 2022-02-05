final: prev: {

  # alacritty-desktop = with prev; makeDesktopItem {
  #   name = "Alacritty";
  #   desktopName = "Alacritty";
  #   exec = "WAYLAND_DISPLAY= alacritty";
  # };

  # alacritty-desktop = with prev; symlinkJoin {
  #   name = "Alacritty";
  #   paths = [ pkgs.alacritty ];
  #   nativeBuildInputs = [ pkgs.makeWrapper ];
  #   postBuild = ''
  #     wrapProgram $out/bin/alacritty \
  #       --add-flags "WAYLAND_DISPLAY="
  #       '';
  # };

  # package = pkgs.alacritty.overrideAttrs (attrs: {
  #   postInstall = attrs.postInstall + ''
  #         substituteInPlace $out/share/applications/alacritty.desktop \
  #           --replace 'Exec=alacritty' 'Exec=WAYLAND_DISPLAY= alacritty'
  #       '';
  # });

  # slack = prev.slack.overrideAttrs (oldAttrs: {
  #   postInstall = (oldAttrs.postInstall or "") + ''
  #     substituteInPlace $out/share/applications/slack.desktop \
  #       --replace "/bin/slack %U" "/bin/slack %U --disable-smooth-scrolling"
  #   '';
  # });

  # alacritty-desktop = prev.alacritty.overrideAttrs (oldAttrs: rec {
  #   desktopItem = oldAttrs.desktopItem.override {
  #   exec = "env WAYLAND_DISPLAY= alacritty";
  # };
  #   postInstall = builtins.replaceStrings [ "${oldAttrs.desktopItem}" ] [ "${desktopItem}" ] oldAttrs.postInstall;
  # });


}
