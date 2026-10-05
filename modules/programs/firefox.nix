{ ... }:
{
  flake.homeModules.firefox =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.repo.programs.firefox.enable = lib.mkEnableOption "Enable firefox.";

      config = lib.mkIf config.repo.programs.firefox.enable {
        home.packages = [
          (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true; }) { })
        ];
      };
    };
}
