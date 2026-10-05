{ ... }:
{
  flake.nixosModules.amd-gpu =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.repo.infra.gpu.amd.enable = lib.mkEnableOption "Enable amdgpu.";

      config = lib.mkIf config.repo.infra.gpu.amd.enable {
        boot.initrd.kernelModules = [ "amdgpu" ];
        hardware.graphics = {
          enable = true;
          enable32Bit = true;
        };
        environment.systemPackages = with pkgs; [
          libva-utils
          vrrtest
        ];
      };
    };
}
