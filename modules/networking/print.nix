{
  flake.modules.nixos.print =
    { ... }:
    {
      # Enable CUPS to print documents.
      services.printing.enable = true;
    };
}
