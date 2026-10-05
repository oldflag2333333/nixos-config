{ ... }:
{
  flake.homeModules.base =
    { lib, ... }:
    {
      options.repo = {
        hostName = lib.mkOption {
          type = lib.types.str;
          description = "Host name used by user commands.";
        };
        user = {
          name = lib.mkOption { type = lib.types.str; };
          email = lib.mkOption { type = lib.types.str; };
        };
      };
      config = {
        news.display = "silent";
        programs.home-manager.enable = true;
        xdg.enable = true;
        fonts.fontconfig.enable = true;
        systemd.user.startServices = "sd-switch";
      };
    };
}
