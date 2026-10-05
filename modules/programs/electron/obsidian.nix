{ ... }:
{
  flake.homeModules.obsidian =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.repo.programs.obsidian;
      wrapElectron = pkgs.callPackage ./_wrapper.nix { };
      electronPkg = pkgs.unstable.obsidian;
      package =
        if cfg.enableWayland then
          wrapElectron {
            pkg = electronPkg;
            execName = electronPkg.pname;
          }
        else
          electronPkg;
    in
    {
      options.repo.programs.obsidian = {
        enable = lib.mkEnableOption "Enable obsidian.";
        enableWayland = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable electron wayland patch.";
        };
      };

      config = lib.mkIf cfg.enable {
        home.packages = [ package ];
      };
    };
}
