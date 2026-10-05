{ ... }:
{
  flake.nixosModules.fcitx5 =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.repo.infra.fcitx5.enable = lib.mkEnableOption "Enable fcitx5 input method capability.";

      config = lib.mkIf config.repo.infra.fcitx5.enable {
        i18n.inputMethod = {
          enable = true;
          type = "fcitx5";
          fcitx5 = {
            waylandFrontend = true;
            addons = with pkgs; [
              fcitx5-gtk
              qt6Packages.fcitx5-chinese-addons
            ];
          };
        };
      };
    };

  flake.homeModules.fcitx5 =
    { config, lib, ... }:
    {
      options.repo.infra.fcitx5.setting.enable =
        lib.mkEnableOption "Manage user fcitx5 settings and theme assets.";
      config = lib.mkIf config.repo.infra.fcitx5.setting.enable {
        home.file.".local/share/fcitx5/themes" = {
          recursive = true;
          source = ./fcitx5-themes;
        };
      };
    };
}
