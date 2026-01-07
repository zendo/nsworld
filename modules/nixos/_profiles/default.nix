{
  flake.modules.nixos.default =
    { inputs, ... }:
    {
      imports = [ (inputs.import-tree ../.) ];
    };
}
