{ ... }:
{
  flake.homeModules.telegram-desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.repo.programs.telegram-desktop;
      telegramPkg = pkgs.unstable.telegram-desktop;
      package =
        if cfg.enableWayland then
          pkgs.symlinkJoin {
            name = "telegram-desktop-wayland";
            paths = [ telegramPkg ];
            buildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              wrapProgram $out/bin/Telegram \
                --set QT_QPA_PLATFORM 'wayland;xcb' \
                --set QT_WAYLAND_DISABLE_WINDOWDECORATION 1
              ln -s Telegram $out/bin/telegram-desktop
            '';
          }
        else
          telegramPkg;
    in
    {
      options.repo.programs.telegram-desktop = {
        enable = lib.mkEnableOption "Enable Telegram Desktop.";
        enableWayland = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable Telegram Desktop Wayland support.";
        };
      };

      config = lib.mkIf cfg.enable {
        home.packages = [ package ];
      };
    };
}
