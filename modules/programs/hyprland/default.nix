{ ... }:
{
  flake.nixosModules.hyprland =
    { config, lib, ... }:
    {
      options.repo.programs.hyprland.enable = lib.mkEnableOption "Enable Hyprland program.";
      config = lib.mkIf config.repo.programs.hyprland.enable {
        programs.hyprland.enable = true;
      };
    };

  flake.homeModules.hyprland =
    { config, lib, ... }:
    let
      cfg = config.repo.programs.hyprland.config;
      configPath = ./config;
      hyprlandConfText =
        lib.replaceStrings [ "@MONITOR_CONFIG@" "@EXTRA_CONFIG@" ] [ cfg.monitorConfig cfg.extraConfig ]
          (builtins.readFile (configPath + "/hyprland.conf"));
    in
    {
      options.repo.programs.hyprland.config = {
        enable = lib.mkEnableOption "Manage user Hyprland configuration.";
        monitorConfig = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Host-specific monitor configuration line(s) for hyprland.conf.";
        };
        extraConfig = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Extra lines appended to hyprland.conf (for host-specific cursor, etc.).";
        };
      };

      config = lib.mkIf cfg.enable {
        home.file.".config/hypr/conf" = {
          enable = true;
          recursive = true;
          source = configPath + "/conf";
        };

        home.file.".config/hypr/hyprland.conf" = {
          enable = true;
          force = true;
          text = hyprlandConfText;
        };
      };
    };
}
