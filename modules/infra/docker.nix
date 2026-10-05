{ ... }:
{
  flake.nixosModules.docker =
    { config, lib, ... }:
    {
      options.repo.infra.docker = {
        enable = lib.mkEnableOption "Enable Docker.";
        user = lib.mkOption {
          type = lib.types.str;
          default = config.repo.user.name;
        };
      };

      config = lib.mkIf config.repo.infra.docker.enable {
        virtualisation.docker.enable = true;
        users.users.${config.repo.infra.docker.user}.extraGroups = [ "docker" ];
      };
    };
}
