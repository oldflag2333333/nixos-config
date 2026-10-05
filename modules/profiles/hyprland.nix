{ self, ... }:
{
  flake.nixosModules.hyprland-profile =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        self.nixosModules.hyprland
        self.nixosModules.greetd
        self.nixosModules.thunar
      ];

      options.repo.profiles.hyprland.enable = lib.mkEnableOption "Enable Hyprland profile.";

      config = lib.mkIf config.repo.profiles.hyprland.enable {
        repo.infra.greetd.enable = lib.mkDefault true;
        repo.infra.greetd.defaultSession = lib.mkDefault "${pkgs.hyprland}/share/wayland-sessions";

        repo.programs.hyprland.enable = lib.mkDefault true;
        repo.programs.thunar.enable = lib.mkDefault true;
      };
    };
}
