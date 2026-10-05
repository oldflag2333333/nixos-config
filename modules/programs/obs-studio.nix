{ ... }:
{
  flake.homeModules.obs-studio =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.repo.programs.obs-studio = {
        enable = lib.mkEnableOption "Enable OBS Studio.";
        lookingGlassPlugin = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable the Looking Glass plugin for OBS Studio.";
        };
      };

      config = lib.mkIf config.repo.programs.obs-studio.enable {
        programs.obs-studio = {
          enable = true;
          package = pkgs.unstable.obs-studio;
          plugins =
            with pkgs.unstable.obs-studio-plugins;
            [
              wlrobs
              obs-vaapi
              obs-gstreamer
            ]
            ++ lib.optional config.repo.programs.obs-studio.lookingGlassPlugin looking-glass-obs;
        };
      };
    };
}
