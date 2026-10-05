{ ... }:
{
  flake.nixosModules.intel-gpu =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.repo.infra.gpu.intel.enable = lib.mkEnableOption "Enable Intel integrated graphics.";

      config = lib.mkIf config.repo.infra.gpu.intel.enable {
        boot.initrd.kernelModules = [ "i915" ];
        hardware.graphics = {
          enable = true;
          enable32Bit = true;
          extraPackages = with pkgs; [
            intel-media-driver
            intel-vaapi-driver
          ];
        };
        environment.systemPackages = with pkgs; [
          libva-utils
          intel-gpu-tools
        ];
      };
    };
}
