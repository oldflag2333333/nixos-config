{ ... }:
{
  flake.homeModules.nodejs =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.repo.programs.nodejs.enable = lib.mkEnableOption "Enable Node.js.";

      config = lib.mkIf config.repo.programs.nodejs.enable {
        home.packages = [ pkgs.nodejs ];
        home.sessionPath = [ "$HOME/.npm-global/bin" ];

        programs.zsh.envExtra = lib.mkAfter ''
          export NPM_CONFIG_PREFIX="$HOME/.npm-global"
          export PATH="$HOME/.npm-global/bin:$PATH"
        '';
      };
    };
}
