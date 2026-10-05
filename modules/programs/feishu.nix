{ ... }:
{
  flake.homeModules.feishu =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.repo.programs.feishu.enable = lib.mkEnableOption "Enable Feishu.";

      config = lib.mkIf config.repo.programs.feishu.enable {
        home.packages = [ pkgs.unstable.feishu ];
      };
    };
}
