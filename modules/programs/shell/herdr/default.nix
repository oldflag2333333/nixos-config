{ ... }:
{
  flake.homeModules.herdr =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.repo.programs.herdr.enable = lib.mkEnableOption "Enable Herdr agent multiplexer.";

      config = lib.mkIf config.repo.programs.herdr.enable {
        home.packages = [ pkgs.unstable.herdr ];

        home.file.".config/herdr/config.toml" = {
          source = ./config.toml;
          force = true;
        };
      };
    };
}
