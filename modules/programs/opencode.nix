{ ... }:
{
  flake.homeModules.opencode =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.repo.programs.opencode.enable = lib.mkEnableOption "Enable opencode.";

      config = lib.mkIf config.repo.programs.opencode.enable {
        home.sessionPath = [ "$HOME/.local/bin" ];

        programs.opencode = {
          enable = true;
          package = pkgs.unstable.opencode;
        };

        programs.zsh.envExtra = ''
          export OPENCODE_DISABLE_CHANNEL_DB=true
          export OPENTUI_FORCE_WCWIDTH=1
        '';
      };
    };
}
