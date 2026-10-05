{ ... }:
{
  flake.homeModules.shell =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      userName = config.repo.user.name;
      userEmail = config.repo.user.email;
      hostName = config.repo.hostName;
      dataHome = config.xdg.dataHome;
      p10k = pkgs.unstable.zsh-powerlevel10k;
      p10kTheme = "${p10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      flakePath = "${config.home.homeDirectory}/.flake";
      systemFlake = "${flakePath}#${hostName}";
      userFlake = "${flakePath}#${userName}@${hostName}";
      commandsFile = pkgs.writeText "environment-commands.zsh" (
        lib.replaceStrings
          [ "@FLAKE_PATH@" "@SYSTEM_FLAKE@" "@USER_FLAKE@" ]
          [
            (lib.escapeShellArg flakePath)
            (lib.escapeShellArg systemFlake)
            (lib.escapeShellArg userFlake)
          ]
          (builtins.readFile ./scripts/environment-commands.zsh)
      );

      zshConfigEarlyInit = lib.mkOrder 500 ''
        if [[ -r "$''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$''${(%):-%n}.zsh" ]]; then
          source "$''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$''${(%):-%n}.zsh"
        fi
      '';

      zshConfig = lib.mkOrder 1000 ''
        bindkey -r '^D'
        source ${p10kTheme}
        source ${./scripts/p10k.zsh}

        # Autosuggest settings.
        bindkey '^n' autosuggest-accept
        ZSH_AUTOSUGGEST_STRATEGY=(history completion)

        # Fzf settings.
        bindkey -r '^T'
        bindkey -M emacs '^F' fzf-file-widget
        bindkey -M vicmd '^F' fzf-file-widget
        bindkey -M viins '^F' fzf-file-widget

        source ${commandsFile}
      '';
    in
    {
      options.repo.programs.shell.enable = lib.mkEnableOption "Enable shared shell environment.";

      config = lib.mkIf config.repo.programs.shell.enable {
        repo.programs = {
          herdr.enable = lib.mkDefault true;
          neovim.enable = lib.mkDefault true;
          yazi.enable = lib.mkDefault true;
        };

        home.checks = [
          (pkgs.callPackage ./_commands-check.nix {
            inherit
              commandsFile
              flakePath
              systemFlake
              userFlake
              ;
          })
        ];

        home.packages = with pkgs.unstable; [
          termdown
          zip
          unzip
          jq
          btop
          p10k
        ];

        programs = {
          zsh = {
            enable = true;
            package = pkgs.zsh;
            enableCompletion = true;
            autosuggestion.enable = true;
            dotDir = "${config.xdg.configHome}/zsh";
            initContent = lib.mkMerge [
              zshConfigEarlyInit
              zshConfig
            ];
            syntaxHighlighting = {
              enable = true;
              styles = {
                path = "fg=blue";
                path_prefix = "fg=blue";
                precommand = "fg=magenta";
              };
            };
            shellAliases = {
              ls = "ls --color=auto";
              delete-gen = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations";
              deproxy = ''
                unset http_proxy
                unset https_proxy
                unset HTTP_PROXY
                unset HTTPS_PROXY
              '';
              reproxy = ''
                export http_proxy=http://127.0.0.1:1081
                export https_proxy=http://127.0.0.1:1081
                export HTTP_PROXY=http://127.0.0.1:1081
                export HTTPS_PROXY=http://127.0.0.1:1081
              '';
            };
            history = {
              save = 10000;
              path = "${dataHome}/zsh/zsh_history";
            };
            envExtra = ''
              export LESSHISTFILE="$HOME/.local/state/lesshst"
              export _ZO_MAXAGE=5000
            '';
          };

          fzf = {
            enable = true;
            package = pkgs.fzf;
            enableZshIntegration = true;
          };

          zoxide = {
            enable = true;
            package = pkgs.unstable.zoxide;
            enableZshIntegration = true;
            options = [ "--cmd cd" ];
          };

          direnv = {
            enable = true;
            package = pkgs.unstable.direnv;
            enableZshIntegration = true;
            nix-direnv.enable = true;
          };

          git = {
            enable = true;
            settings = {
              user.name = userName;
              user.email = userEmail;
            };
            ignores = [
              "**/.sisyphus"
              "**/.omo"
              "**/.vscode"
              "**/.mvn"
              "**/.settings"
              "**/.classpath"
              "**/.factorypath"
              "**/.project"
            ];
          };

          gh.enable = true;

          lazygit = {
            enable = true;
            package = pkgs.unstable.lazygit;
          };

          less = {
            enable = true;
            # Exit less by h.
            # More intuitive for joshuto preview.
            config = "h quit";
          };

          bat = {
            enable = true;
            themes = {
              tokyonight_day = {
                src = ./themes;
                file = "tokyonight_day.tmTheme";
              };
              tokyonight_moon = {
                src = ./themes;
                file = "tokyonight_moon.tmTheme";
              };
              tokyonight_night = {
                src = ./themes;
                file = "tokyonight_night.tmTheme";
              };
              tokyonight_storm = {
                src = ./themes;
                file = "tokyonight_storm.tmTheme";
              };
            };
            config.theme = "tokyonight_night";
          };
        };

        home.file.".config/btop/btop.conf" = {
          enable = true;
          source = ./btop.conf;
        };
      };
    };
}
