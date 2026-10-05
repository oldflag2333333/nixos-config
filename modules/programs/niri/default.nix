{ ... }:
{
  flake.nixosModules.niri =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.repo.programs.niri;
      configPath = ./config.kdl;
    in
    {
      options.repo.programs.niri.enable = lib.mkEnableOption "Enable Niri program.";

      config = lib.mkIf cfg.enable {
        assertions = [
          {
            assertion = builtins.pathExists configPath;
            message = "Niri is enabled for `${config.networking.hostName}`, but `${toString configPath}` is missing.";
          }
        ];

        programs.niri.enable = true;

        # Niri 25.08+ auto-integrates with xwayland-satellite when it is in PATH.
        environment.systemPackages = [ pkgs.xwayland-satellite ];
      };
    };

  flake.homeModules.niri =
    {
      config,
      lib,
      pkgs,
      systemPkgs,
      ...
    }:
    let
      cfg = config.repo.programs.niri.config;
      configPath = ./config.kdl;
      sattyConfigPath = ./satty-config.toml;
    in
    {
      options.repo.programs.niri.config.enable =
        lib.mkEnableOption "Manage user Niri configuration and screenshot helpers.";

      config = lib.mkIf cfg.enable {
        home.packages = [
          pkgs.grim
          pkgs.slurp
          pkgs.satty
          pkgs.wl-clipboard

          (pkgs.writeShellApplication {
            name = "screenshot-region";
            runtimeInputs = [
              pkgs.coreutils
              pkgs.slurp
              pkgs.grim
              pkgs.wl-clipboard
            ];
            text = ''
              GEOM=$(slurp) || exit 0
              mkdir -p "$HOME/Pictures/Screenshots"
              FILE="$HOME/Pictures/Screenshots/screenshot-region-$(date +%Y-%m-%d_%H-%M-%S).png"
              grim -g "$GEOM" "$FILE"
              wl-copy --type image/png < "$FILE"
            '';
          })

          (pkgs.writeShellApplication {
            name = "screenshot-screen";
            runtimeInputs = [
              pkgs.coreutils
              pkgs.grim
              pkgs.wl-clipboard
            ];
            text = ''
              mkdir -p "$HOME/Pictures/Screenshots"
              FILE="$HOME/Pictures/Screenshots/screenshot-screen-$(date +%Y-%m-%d_%H-%M-%S).png"
              grim "$FILE"
              wl-copy --type image/png < "$FILE"
            '';
          })

          (pkgs.writeShellApplication {
            name = "screenshot-window";
            runtimeInputs = [
              pkgs.coreutils
              systemPkgs.niri
              pkgs.wl-clipboard
              pkgs.gnugrep
            ];
            text = ''
              mkdir -p "$HOME/Pictures/Screenshots"
              FILE="$HOME/Pictures/Screenshots/screenshot-window-$(date +%Y-%m-%d_%H-%M-%S).png"
              niri msg action screenshot-window -d false
              for _ in $(seq 1 10); do
                sleep 0.2
                if wl-paste --list-types 2>/dev/null | grep -q 'image/png'; then
                  wl-paste --type image/png > "$FILE"
                  wl-copy --type image/png < "$FILE"
                  exit 0
                fi
              done

              exit 1
            '';
          })
        ];

        home.file = {
          ".config/niri/config.kdl" = {
            enable = true;
            force = true;
            source = configPath;
          };

          ".config/satty/config.toml" = {
            enable = true;
            force = true;
            source = sattyConfigPath;
          };
        };
      };
    };
}
