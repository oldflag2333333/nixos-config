{ inputs, ... }:
{
  flake.homeModules.pi =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.repo.programs.pi.enable = lib.mkEnableOption "Enable pi coding agent.";

      config = lib.mkIf config.repo.programs.pi.enable {
        home.packages = [ inputs.pi.packages.${pkgs.stdenv.hostPlatform.system}.default ];

        home.file = {
          ".pi/agent/themes/tokyo-night.json" = {
            source = ./tokyo-night.json;
            force = true;
          };

          # Report Pi state and session metadata to the Herdr pane socket.
          ".pi/agent/extensions/herdr-agent-state.ts" = {
            source = "${pkgs.unstable.herdr.src}/src/integration/assets/pi/herdr-agent-state.ts";
            force = true;
          };
        };
      };
    };
}
