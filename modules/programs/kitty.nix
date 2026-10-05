{ ... }:
{
  flake.homeModules.kitty =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.repo.programs.kitty.enable = lib.mkEnableOption "Enable kitty.";

      config = lib.mkIf config.repo.programs.kitty.enable {
        programs.kitty = {
          enable = true;
          package = pkgs.kitty;
          themeFile = "tokyo_night_moon";
          font = {
            name = "Maple Mono NL NF CN";
            size = 14.0;
          };
          shellIntegration = {
            mode = "no-cursor";
            enableZshIntegration = true;
          };
          settings = {
            hide_window_decorations = "yes";
            cursor_shape = "block";
            underline_hyperlinks = "never";
            # Herdr owns tabs, splits, and pane navigation; Kitty is only the
            # outer terminal surface.
            tab_bar_style = "hidden";
            # Enable remote control via socket only (secure)
            allow_remote_control = "socket-only";
            # Use a fixed socket name - only the first kitty instance will listen
            listen_on = "unix:@kitty";
          };
          keybindings = {
            "ctrl+c" = "copy_or_interrupt";
            "ctrl+v" = "paste_from_clipboard";
            "ctrl+d" = "scroll_page_down";
            "ctrl+u" = "scroll_page_up";
          };
        };

        # Copy terminfo to remote machine.
        programs.zsh = {
          shellAliases = {
            ssh = "kitty +kitten ssh";
          };
        };
      };
    };
}
