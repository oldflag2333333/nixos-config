{ self, ... }:
{
  flake.nixosModules.general =
    { config, lib, ... }:
    {
      imports = [
        self.nixosModules.common
      ];

      options.repo.profiles.general.enable = lib.mkEnableOption "Enable general profile.";

      config = lib.mkIf config.repo.profiles.general.enable {
        repo.infra.common.enable = lib.mkDefault true;

        services.openssh.enable = lib.mkDefault true;
      };
    };
}
