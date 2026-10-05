{ self, ... }:
{
  flake.nixosModules.desktop =
    { config, lib, ... }:
    {
      imports = [
        self.nixosModules.audio
        self.nixosModules.fonts
        self.nixosModules.fcitx5
      ];
      options.repo.profiles.desktop.enable = lib.mkEnableOption "Enable desktop profile.";
      config = lib.mkIf config.repo.profiles.desktop.enable {
        repo.infra.audio.enable = lib.mkDefault true;
        repo.infra.fonts.enable = lib.mkDefault true;
        repo.infra.fcitx5.enable = lib.mkDefault true;
      };
    };

  flake.homeModules.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.repo.profiles.desktop.enable = lib.mkEnableOption "Enable user desktop utilities.";
      config = lib.mkIf config.repo.profiles.desktop.enable {
        programs.mpv = {
          enable = lib.mkDefault true;
          package = lib.mkDefault pkgs.mpv;
          config.hwdec = lib.mkDefault "auto";
        };
        services.playerctld = {
          enable = lib.mkDefault true;
          package = lib.mkDefault pkgs.unstable.playerctl;
        };
      };
    };
}
