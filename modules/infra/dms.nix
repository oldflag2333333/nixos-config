{ inputs, ... }:
{
  flake.nixosModules.dms =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.dms.nixosModules.dank-material-shell ];

      options.repo.infra.dms = {
        enable = lib.mkEnableOption "Enable Dank Material Shell on ${pkgs.stdenv.hostPlatform.system}.";
      };

      config = lib.mkIf config.repo.infra.dms.enable {
        programs.dank-material-shell.enable = true;
      };
    };

  flake.homeModules.dms =
    { config, lib, ... }:
    {
      imports = [ inputs.dms.homeModules.dank-material-shell ];
      options.repo.infra.dms.userService.enable = lib.mkEnableOption "Enable the user's DMS service.";
      config = lib.mkIf config.repo.infra.dms.userService.enable {
        programs.dank-material-shell.enable = true;
        programs.dank-material-shell.systemd.enable = true;
      };
    };
}
