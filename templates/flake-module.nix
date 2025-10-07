{
  flake.templates = {
    # nix flake init -t github:zendo/nsworld#hello-parts
    hello-parts = {
      description = ''
        Hello parts!
      '';
      path = ./hello-parts;
    };
  };
}
