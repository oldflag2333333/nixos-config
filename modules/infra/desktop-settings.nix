{ ... }:
{
  flake.homeModules.desktop-settings =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.repo.infra.desktopSettings;
      presets = {
        flat-remix =
          let
            gtkTheme = {
              package = pkgs.flat-remix-gtk;
              name = "Flat-Remix-GTK-Grey-Dark";
            };
          in
          {
            cursor = {
              package = pkgs.bibata-cursors;
              name = "Bibata-Modern-Classic";
              size = 22;
            };
            inherit gtkTheme;
            # GTK4 主题，当前跟随 GTK3 以保留 26.05 前的旧行为
            gtk4Theme = gtkTheme;
            iconTheme = {
              package = pkgs.adwaita-icon-theme;
              name = "Adwaita";
            };
          };
        tokyo-night =
          let
            gtkTheme = {
              package = pkgs.tokyonight-gtk-theme;
              name = "Tokyonight-Dark";
            };
          in
          {
            cursor = {
              package = pkgs.bibata-cursors;
              name = "Bibata-Modern-Classic";
              size = 22;
            };
            inherit gtkTheme;
            # GTK4 主题，当前跟随 GTK3 以保留 26.05 前的旧行为
            gtk4Theme = gtkTheme;
            iconTheme = {
              package = pkgs.papirus-icon-theme;
              name = "Papirus-Dark";
            };
          };
      };
      selectedPreset = presets.${cfg.preset};
      browser = "firefox.desktop";
      player = "mpv.desktop";
    in
    {
      options.repo.infra.desktopSettings = {
        enable = lib.mkEnableOption "Enable user desktop appearance and default application settings.";
        preset = lib.mkOption {
          type = lib.types.enum [
            "flat-remix"
            "tokyo-night"
          ];
          default = "flat-remix";
          description = "Desktop appearance preset for shared GTK, icon, and cursor theming.";
        };
      };

      config = lib.mkIf cfg.enable {
        home.pointerCursor = {
          gtk.enable = true;
          inherit (selectedPreset.cursor) package name size;
        };

        gtk = {
          enable = true;
          cursorTheme = {
            inherit (selectedPreset.cursor) package name size;
          };
          theme = {
            package = selectedPreset.gtkTheme.package;
            name = selectedPreset.gtkTheme.name;
          };
          iconTheme = {
            package = selectedPreset.iconTheme.package;
            name = selectedPreset.iconTheme.name;
          };
          gtk4.theme = {
            package = selectedPreset.gtk4Theme.package;
            name = selectedPreset.gtk4Theme.name;
          };
        };

        xdg.mimeApps = {
          enable = true;
          associations.added = {
            "text/html" = browser;
            "x-scheme-handler/http" = browser;
            "x-scheme-handler/https" = browser;
            "x-scheme-handler/about" = browser;
            "application/x-extension-htm" = browser;
            "application/x-extension-html" = browser;
            "application/x-extension-shtml" = browser;
            "application/xhtml+xml" = browser;
            "application/x-extension-xhtml" = browser;
            "application/x-extension-xht" = browser;
            "video/mp4" = player;
          };
          defaultApplications = {
            "application/pdf" = browser;
            "text/html" = browser;
            "x-scheme-handler/http" = browser;
            "x-scheme-handler/https" = browser;
            "x-scheme-handler/about" = browser;
            "application/x-extension-htm" = browser;
            "application/x-extension-html" = browser;
            "application/x-extension-shtml" = browser;
            "application/xhtml+xml" = browser;
            "application/x-extension-xhtml" = browser;
            "application/x-extension-xht" = browser;
            "video/mp4" = player;
          };
        };
      };
    };
}
