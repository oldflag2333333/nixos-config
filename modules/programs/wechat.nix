{ ... }:
{
  flake.homeModules.wechat =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.repo.programs.wechat.enable = lib.mkEnableOption "Enable wechat.";

      config = lib.mkIf config.repo.programs.wechat.enable {
        home.packages = [ pkgs.wechat ];
      };
    };
}
