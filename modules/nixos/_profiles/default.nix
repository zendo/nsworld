{
  flake.modules.nixos.default =
    { inputs, ... }:
    {
      imports = [
        (inputs.import-tree ../.)
        inputs.self.modules.nixos.secrets
      ];
    };
}
