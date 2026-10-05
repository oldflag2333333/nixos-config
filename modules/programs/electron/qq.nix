{ ... }:
{
  flake.homeModules.qq =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.repo.programs.qq;
      electronPkg = pkgs.unstable.qq;
      package =
        if cfg.enableWayland then
          electronPkg.override {
            commandLineArgs = lib.concatStringsSep " " [
              "--ozone-platform=wayland"
              "--enable-features=WaylandWindowDecorations"
              "--enable-wayland-ime=true"
              "--wayland-text-input-version=3"
            ];
          }
        else
          electronPkg;
    in
    {
      options.repo.programs.qq = {
        enable = lib.mkEnableOption "Enable qq.";
        enableWayland = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable electron wayland patch.";
        };
      };

      config = lib.mkIf cfg.enable {
        home.packages = [ package ];
      };
    };
}
