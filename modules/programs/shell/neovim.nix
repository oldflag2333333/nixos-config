{ ... }:
{
  flake.homeModules.neovim =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      location = ".local/share/nvim/nix";
      telescope-fzf = pkgs.unstable.vimPlugins.telescope-fzf-native-nvim;
      treesitters = pkgs.unstable.vimPlugins.nvim-treesitter.withAllGrammars;
      treesitter-parsers = pkgs.symlinkJoin {
        name = "treesitter-parsers";
        paths = treesitters.dependencies;
      };
    in
    {
      options.repo.programs.neovim.enable = lib.mkEnableOption "Enable neovim.";

      config = lib.mkIf config.repo.programs.neovim.enable {
        home.packages = with pkgs.unstable; [
          ripgrep
          fd
          stylua
          shfmt
          nixfmt
          prettierd
          rustywind
          lua-language-server
          nixd
          rust-analyzer
          taplo
          lldb
          typescript-language-server
        ];

        programs.neovim = {
          enable = true;
          package = pkgs.unstable.neovim-unwrapped;
          defaultEditor = true;
          viAlias = true;
          vimAlias = true;
          withNodeJs = false;
          withPython3 = false;
          withRuby = false;
          extraLuaPackages = ps: [ ps.jsregexp ];
          initLua = ''
            require 'oldvim'
          '';
        };

        home.file.".config/nvim" = {
          enable = false;
          recursive = true;
          source = ./config;
        };

        home.file."${location}/telescope-fzf-native.nvim" = {
          enable = true;
          source = telescope-fzf;
        };

        home.file.".local/share/nvim/lazy/nvim-treesitter/parser" = {
          enable = true;
          recursive = true;
          source = "${treesitter-parsers}/parser";
        };
      };
    };
}
