/*
  lspci -k | grep -EA3 'VGA|Display'
  nix shell nixpkgs#mesa-demos nixpkgs#vulkan-tools nixpkgs#libva-utils
  glxinfo -B
  vulkaninfo --summary
  vainfo # VA-API 硬解能力（libva-utils）

  NVIDIA：本仓库目前没有 NVIDIA 主机，需要时再按下面的链接补模块
  https://wiki.nixos.org/wiki/NVIDIA
  https://github.com/NixOS/nixos-hardware/tree/master/common/gpu/nvidia
*/
{
  # https://wiki.nixos.org/wiki/AMD_GPU
  # https://github.com/NixOS/nixos-hardware/blob/master/common/gpu/amd/default.nix
  flake.modules.nixos.gpu-amd =
    { lib, ... }:
    {
      hardware.graphics.enable = lib.mkDefault true;

      # early boot：把 amdgpu 塞进 stage-1，只用于修 initramfs 阶段的低分辨率。
      # 代价是 initrd 变大、boot 稍慢；启动画面分辨率正常的话可以删掉这一行。
      # hardware.amdgpu.initrd.enable = lib.mkDefault true;

      # OpenCL（ROCm CLR），需要 Blender / Darktable / ROCm 时再打开，体积较大：
      # hardware.amdgpu.opencl.enable = true;
    };

  # https://wiki.nixos.org/wiki/Intel_Graphics
  # https://github.com/NixOS/nixos-hardware/blob/master/common/gpu/intel/default.nix
  flake.modules.nixos.gpu-intel =
    { lib, pkgs, ... }:
    {
      hardware.graphics = {
        enable = lib.mkDefault true;
        extraPackages = with pkgs; [
          # Broadwell(2014) 及更新用 iHD；Gen8 及更早才用（已不再维护的）i965
          intel-media-driver
          # vpl-gpu-rt # QSV / oneVPL，Tiger Lake 及更新
          # intel-vaapi-driver # 仅 Gen8 及更早
        ];
        # extraPackages32 = with pkgs.pkgsi686Linux; [
        #   intel-media-driver
        # ];
      };
    };
}
