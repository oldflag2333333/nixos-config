{ ... }:
{
  flake.homeModules.brave =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.repo.programs.brave.enable = lib.mkEnableOption "Enable brave.";

      config = lib.mkIf config.repo.programs.brave.enable {
        home.packages = [ pkgs.brave ];
      };
    };
}
