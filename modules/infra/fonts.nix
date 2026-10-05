{ ... }:
{
  flake.nixosModules.fonts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.repo.infra.fonts.enable = lib.mkEnableOption "Enable CJK support.";

      config = lib.mkIf config.repo.infra.fonts.enable {
        fonts = {
          packages = with pkgs.unstable; [
            maple-mono.NL-NF-CN-unhinted
            maple-mono.NF-CN-unhinted
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-cjk-serif
            twemoji-color-font
          ];

          enableDefaultPackages = false;

          fontconfig.defaultFonts = {
            serif = [
              "Noto Serif"
              "Noto Serif CJK SC"
              "Noto Serif CJK TC"
              "Twitter Color Emoji"
            ];
            sansSerif = [
              "Noto Sans"
              "Noto Sans CJK SC"
              "Noto Sans CJK TC"
              "Twitter Color Emoji"
            ];
            monospace = [
              "Maple Mono NL NF CN"
              "Noto Sans Mono"
              "Noto Sans Mono CJK SC"
              "Noto Sans Mono CJK TC"
              "Twitter Color Emoji"
            ];
            emoji = [ "Twitter Color Emoji" ];
          };
        };
      };
    };
}
