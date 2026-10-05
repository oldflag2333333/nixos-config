{ ... }:
{
  flake.nixosModules.greetd =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.repo.infra.greetd = {
        enable = lib.mkEnableOption "Enable greetd";
        defaultSession = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Default session";
        };
      };

      config = lib.mkMerge [
        {
          assertions = [
            {
              assertion = (!config.repo.infra.greetd.enable) || (config.repo.infra.greetd.defaultSession != null);
              message = "repo.infra.greetd.defaultSession must be set when greetd is enabled.";
            }
          ];
        }
        (lib.mkIf (config.repo.infra.greetd.enable && config.repo.infra.greetd.defaultSession != null) {
          services.greetd = {
            enable = true;
            settings.default_session = {
              command = lib.strings.concatStrings [
                "${pkgs.tuigreet}/bin/tuigreet"
                " --time"
                " --remember"
                " --remember-session"
                " --sessions"
                " ${config.repo.infra.greetd.defaultSession}"
              ];
              user = "greeter";
            };
          };

          systemd.services.greetd.serviceConfig = {
            Type = "idle";
            StandardInput = "tty";
            StandardOutput = "tty";
            StandardError = "journal";
            TTYReset = true;
            TTYVHangup = true;
            TTYVTDisallocate = true;
          };
        })
      ];
    };
}
