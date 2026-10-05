{ ... }:
{
  flake.nixosModules.steam =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.repo.programs.steam.enable = lib.mkEnableOption "Enable steam.";

      config = lib.mkIf config.repo.programs.steam.enable {
        programs = {
          steam.enable = true;
          gamemode.enable = true;
        };

        environment.systemPackages = with pkgs; [ mangohud ];
      };
    };
}
