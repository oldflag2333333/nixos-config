{
  pkgs,
  commandsFile,
  flakePath,
  systemFlake,
  userFlake,
}:
pkgs.runCommand "environment-commands-check"
  {
    nativeBuildInputs = [ pkgs.zsh ];
  }
  ''
    zsh ${./scripts/_test-environment-commands.zsh} ${commandsFile} \
      ${pkgs.lib.escapeShellArg systemFlake} ${pkgs.lib.escapeShellArg userFlake} \
      ${pkgs.lib.escapeShellArg flakePath}
    touch "$out"
  ''
