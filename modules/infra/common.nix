{ ... }:
{
  flake.nixosModules.common =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.repo.infra.common.enable = lib.mkEnableOption "Some common packages.";

      config = lib.mkIf config.repo.infra.common.enable {
        environment.systemPackages = with pkgs; [
          wget
          curl
          file
          lsof
          whois
          traceroute
          iproute2
          pciutils
          libnotify
          trash-cli
        ];

        programs.zsh.enable = true;
        environment.pathsToLink = [ "/share/zsh" ];
      };
    };
}
