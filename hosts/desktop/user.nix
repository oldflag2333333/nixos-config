{ ... }:
{
  repo.userEnvironments.desktop = {
    user = import ../_user.nix;
    stateVersion = "25.11";
    configuration = {
      repo = {
        profiles.desktop.enable = true;
        infra = {
          dms.userService.enable = true;
          fcitx5.setting.enable = true;
          desktopSettings = {
            enable = true;
            preset = "tokyo-night";
          };
        };
        programs = {
          shell.enable = true;
          kitty.enable = true;
          nodejs.enable = true;
          pi.enable = true;
          opencode.enable = false;
          firefox.enable = true;
          obsidian.enable = true;
          feishu.enable = true;
          qq = {
            enable = true;
            enableWayland = true;
          };
          telegram-desktop.enable = true;
          obs-studio.enable = true;
          niri.config.enable = true;
        };
      };
    };
  };
}
