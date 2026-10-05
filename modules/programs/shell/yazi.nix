{ ... }:
{
  flake.homeModules.yazi =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.repo.programs.yazi.enable = lib.mkEnableOption "Yazi terminal file manager";

      config = lib.mkIf config.repo.programs.yazi.enable {
        programs.yazi = {
          enable = true;
          package = pkgs.unstable.yazi;
          # 保留 26.05 前的旧行为，wrapper 命令仍为 yy
          shellWrapperName = "yy";

          # 主配置
          settings = {
            mgr = {
              ratio = [
                1
                3
                4
              ];
              sort_by = "natural";
              sort_sensitive = false;
              sort_reverse = false;
              sort_dir_first = true;
              linemode = "size";
              show_hidden = true;
              show_symlink = true;
              scrolloff = 6;
            };

            preview = {
              wrap = "yes"; # 启用自动换行，方便阅读长行文本
              tab_size = 2;
              max_width = 1200;
              max_height = 900;
              image_delay = 50;
              image_filter = "lanczos3";
              image_quality = 80;
            };

            opener = {
              edit = [
                {
                  run = "$EDITOR %s";
                  block = true;
                  for = "unix";
                }
              ];
              open = [
                {
                  run = "xdg-open %s";
                  desc = "Open";
                  for = "unix";
                }
              ];
              play = [
                {
                  run = "mpv %s";
                  orphan = true;
                  for = "unix";
                }
              ];
            };

            open = {
              rules = [
                {
                  mime = "text/*";
                  use = "edit";
                }
                {
                  mime = "video/*";
                  use = "play";
                }
                {
                  mime = "audio/*";
                  use = "play";
                }
                {
                  url = "*.json";
                  use = "edit";
                }
                {
                  url = "*.html";
                  use = [
                    "open"
                    "edit"
                  ];
                }
              ];
            };

            tasks = {
              micro_workers = 8;
              macro_workers = 4;
              bizarre_retry = 3;
              suppress_preload = true;
              image_alloc = 0;
              image_bound = [
                0
                0
              ];
            };

            input = {
              cursor_blink = false;
            };

            which = {
              sort_by = "key";
              sort_sensitive = false;
              sort_reverse = false;
            };
          };

          # 按键映射
          keymap = {
            mgr = {
              prepend_keymap = [
                # Bookmarks
                {
                  on = [
                    "g"
                    "d"
                  ];
                  run = "cd ~/Downloads";
                  desc = "Go to Downloads";
                }
                {
                  on = [
                    "g"
                    "p"
                  ];
                  run = "cd ~/Pictures";
                  desc = "Go to Pictures";
                }
                {
                  on = [
                    "g"
                    "D"
                  ];
                  run = "cd ~/Documents";
                  desc = "Go to Documents";
                }
                {
                  on = [
                    "g"
                    "c"
                  ];
                  run = "cd ~/.config";
                  desc = "Go to Config";
                }
                {
                  on = [
                    "g"
                    "h"
                  ];
                  run = "cd ~";
                  desc = "Go to Home";
                }
              ];
            };
          };

          # 主题配置 - Tokyo Night
          theme = {
            manager = {
              cwd = {
                fg = "#7aa2f7";
              };
              find_keyword = {
                fg = "#e0af68";
                bold = true;
              };
              find_position = {
                fg = "#7dcfff";
              };
              marker_copied = {
                fg = "#9ece6a";
                bg = "#9ece6a";
              };
              marker_cut = {
                fg = "#f7768e";
                bg = "#f7768e";
              };
              marker_marked = {
                fg = "#bb9af7";
                bg = "#bb9af7";
              };
              marker_selected = {
                fg = "#7aa2f7";
                bg = "#7aa2f7";
              };
              border_style = {
                fg = "#565f89";
              };
            };

            status = {
              overall = {
                fg = "#a9b1d6";
                bg = "#1a1b26";
              };
              sep_left = {
                open = "";
                close = "";
              };
              sep_right = {
                open = "";
                close = "";
              };
              perm_type = {
                fg = "#7aa2f7";
              };
              perm_read = {
                fg = "#9ece6a";
              };
              perm_write = {
                fg = "#e0af68";
              };
              perm_exec = {
                fg = "#f7768e";
              };
              progress_label = {
                fg = "#a9b1d6";
                bold = true;
              };
              progress_normal = {
                fg = "#7aa2f7";
              };
              progress_error = {
                fg = "#f7768e";
              };
            };

            tabs = {
              active = {
                fg = "#1a1b26";
                bg = "#7aa2f7";
              };
              inactive = {
                fg = "#a9b1d6";
                bg = "#24283b";
              };
            };

            mode = {
              normal_main = {
                fg = "#1a1b26";
                bg = "#7aa2f7";
                bold = true;
              };
              normal_alt = {
                fg = "#7aa2f7";
                bg = "#24283b";
              };
              select_main = {
                fg = "#1a1b26";
                bg = "#9ece6a";
                bold = true;
              };
              select_alt = {
                fg = "#9ece6a";
                bg = "#24283b";
              };
              unset_main = {
                fg = "#1a1b26";
                bg = "#f7768e";
                bold = true;
              };
              unset_alt = {
                fg = "#f7768e";
                bg = "#24283b";
              };
            };

            filetype = {
              rules = [
                {
                  mime = "image/*";
                  fg = "#e0af68";
                }
                {
                  mime = "video/*";
                  fg = "#bb9af7";
                }
                {
                  mime = "audio/*";
                  fg = "#bb9af7";
                }
                {
                  mime = "application/zip";
                  fg = "#f7768e";
                }
                {
                  mime = "application/gzip";
                  fg = "#f7768e";
                }
                {
                  mime = "application/x-tar";
                  fg = "#f7768e";
                }
                {
                  mime = "application/x-bzip";
                  fg = "#f7768e";
                }
                {
                  mime = "application/x-bzip2";
                  fg = "#f7768e";
                }
                {
                  mime = "application/x-7z-compressed";
                  fg = "#f7768e";
                }
                {
                  mime = "application/x-rar";
                  fg = "#f7768e";
                }
                {
                  url = "*/";
                  fg = "#7aa2f7";
                  bold = true;
                }
                {
                  url = "*";
                  is = "exec";
                  fg = "#9ece6a";
                }
                {
                  url = "*";
                  is = "link";
                  fg = "#7dcfff";
                }
                {
                  url = "*";
                  is = "orphan";
                  fg = "#f7768e";
                }
              ];
            };
          };
        };

        # Zsh 集成 - 目录导航
        programs.zsh.initContent = lib.mkOrder 1000 ''
          # Yazi navigate.
          function yy() {
            local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
            yazi "$@" --cwd-file="$tmp"
            if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
              cd -- "$cwd"
            fi
            rm -f -- "$tmp"
          }
        '';
      };
    };
}
