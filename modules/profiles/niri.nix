{ self, ... }:
{
  flake.nixosModules.niri-profile =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        self.nixosModules.niri
        self.nixosModules.dms
        self.nixosModules.greetd
        self.nixosModules.thunar
      ];

      options.repo.profiles.niri.enable = lib.mkEnableOption "Enable Niri profile.";

      config = lib.mkIf config.repo.profiles.niri.enable {
        repo.infra.dms.enable = lib.mkDefault true;
        repo.infra.greetd.enable = lib.mkDefault true;
        repo.infra.greetd.defaultSession = lib.mkDefault "${pkgs.niri}/share/wayland-sessions";

        repo.programs.niri.enable = lib.mkDefault true;
        repo.programs.thunar.enable = lib.mkDefault true;
      };
    };
}
