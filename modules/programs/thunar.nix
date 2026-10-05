{ ... }:
{
  flake.nixosModules.thunar =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.repo.programs.thunar.enable = lib.mkEnableOption "Enable thunar.";

      config = lib.mkIf config.repo.programs.thunar.enable {
        programs = {
          thunar = {
            enable = true;
            plugins = with pkgs; [
              thunar-archive-plugin
              thunar-volman
            ];
          };
          xfconf.enable = true;
        };

        services = {
          gvfs.enable = true;
          tumbler.enable = true;
        };
      };
    };
}
