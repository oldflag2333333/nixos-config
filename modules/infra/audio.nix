{ ... }:
{
  flake.nixosModules.audio =
    { config, lib, ... }:
    {
      options.repo.infra.audio.enable = lib.mkEnableOption "Enable pipewire.";

      config = lib.mkIf config.repo.infra.audio.enable {
        security.rtkit.enable = true;
        services.pipewire = {
          enable = true;
          pulse.enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
        };
      };
    };
}
