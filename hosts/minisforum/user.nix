{ ... }:
{
  repo.userEnvironments.minisforum = {
    user = import ../_user.nix;
    stateVersion = "25.05";
    configuration = {
      repo = {
        profiles.desktop.enable = true;
        infra = {
          fcitx5.setting.enable = true;
          desktopSettings.enable = true;
        };
        programs = {
          shell.enable = true;
          kitty.enable = true;
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
          wechat.enable = true;
          obs-studio = {
            enable = true;
            lookingGlassPlugin = true;
          };
          hyprland.config = {
            enable = true;
            monitorConfig = "monitor=DP-1,3840x2160@120.00Hz,auto,2,vrr,2";
          };
        };
      };
    };
  };
}
