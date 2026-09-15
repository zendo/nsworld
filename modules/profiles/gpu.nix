{
  # https://wiki.nixos.org/wiki/AMD_GPU
  # https://github.com/NixOS/nixos-hardware/blob/master/common/gpu/amd/default.nix
  flake.modules.nixos.gpu-amd = {
    hardware.graphics = {
      enable = true;
      # enable32Bit = true;
    };

    # early boot
    hardware.amdgpu.initrd.enable = true;
  };

  # https://wiki.nixos.org/wiki/Intel_Graphics
  # https://github.com/NixOS/nixos-hardware/blob/master/common/gpu/intel/default.nix
  flake.modules.nixos.gpu-intel = { pkgs, ... }: {
    hardware.graphics = {
      enable = true;
      # enable32Bit = true;
      extraPackages = with pkgs; [
        # Older Intel GPUs
        intel-vaapi-driver

        # Modern Intel GPUs
        # intel-media-driver # VA-API (iHD) userspace
        # vpl-gpu-rt # oneVPL (QSV) runtime

        # Optional (compute / tooling):
        # intel-compute-runtime
      ];
      # extraPackages32 = with pkgs; [
      #   # intel-vaapi-driver-32 # older
      #   intel-media-driver-32 # newer
      # ];
    };
  };

  # https://wiki.nixos.org/wiki/NVIDIA
  # https://github.com/NixOS/nixos-hardware/tree/master/common/gpu/nvidia
  # flake.modules.nixos.nvidia = {
  # };
}
