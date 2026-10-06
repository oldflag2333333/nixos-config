# NixOS Flake

Public snapshot of my personal NixOS configuration, published without the private module or the original repository history. Host identity and hardware settings
are machine-specific; review them before using this configuration.

One flake, two independently deployed environments:

- **NixOS** owns the kernel, drivers, services, login shell and desktop infrastructure.
- **Standalone Home Manager** owns user applications, shell integrations and user configuration files.

Application selection lives in each host's `hosts/<host>/user.nix`. Implementation and configuration assets remain with the owning module; there is no `modules/home/` tree.

## Layout

```text
.
|- flake.nix
|- flake.lock
|- flake/
|  |- flake-parts.nix
|  |- home-configurations.nix   # Assemble standalone Home Manager outputs
|  |- hosts.nix
|  |- packages.nix            # Assemble custom packages via perSystem
|  |- public-modules.nix
|  `- overlays.nix
|- hosts/
|  |- _user.nix               # Shared username and email
|  |- desktop/
|  |  |- default.nix           # System selections
|  |  `- user.nix              # User/application selections
|  `- minisforum/
|     |- default.nix
|     `- user.nix
|- modules/
|  |- infra/
|  |- profiles/
|  `- programs/
|- overlays/
`- pkgs/
```

## Ownership

| System: `nixosConfigurations.<host>` | User: `homeConfigurations."oldflag@<host>"` |
| --- | --- |
| Kernel, boot, networking, GPU, audio, fonts | Shell configuration, plugins and terminal tools |
| Niri / Hyprland, DMS system package, login manager | Compositor configuration, screenshot tools, DMS user service |
| Fcitx5, Thunar and supporting services | Fcitx5 theme, GTK appearance and MIME defaults |
| Login Zsh, basic system commands | User Zsh, Git, Neovim, Yazi, Lazygit, Kitty, Node.js |
| Steam, GameMode, MangoHud | Pi, Herdr, Obsidian, Firefox, QQ, Feishu, Telegram, OBS + plugins |
| System identity and hardware facts | MPV and playerctl; WeChat remains enabled only on minisforum |

Both output types share the repository, not their deployment lifecycle. There is only one Home Manager owner per user: the NixOS Home Manager integration is no longer imported.

## Architecture

- `flake.nix` loads `./flake` using `flake-parts` and `import-tree`; all outputs are assembled within flake-parts.
- `flake/packages.nix` prepares the per-system package set from system pins and overlays, and exports `pkgs/` through `perSystem.packages` so package definitions from other modules can merge.
- `flake/hosts.nix` discovers each host's top-level Nix files; host directories and files starting with `_` are skipped. Same-name host modules merge automatically.
- `flake/public-modules.nix` registers Home Manager's flake-parts options and discovers `modules/` recursively.
- System modules export `flake.nixosModules.*`; user modules export `flake.homeModules.*`.
- A feature with both kinds of configuration exports both from the **same owning file**, e.g. Niri, DMS and Fcitx5.
- `flake/home-configurations.nix` defines the `repo.userEnvironments` declaration interface, prepares package sets, and assembles standalone `homeConfigurations` and checks. It imports registered Home Manager modules without evaluating a NixOS host to obtain user configuration.
- `modules/infra/user-environment.nix` exports only the common user base module: user/host option declarations, the Home Manager CLI, XDG, user fontconfig and user-service activation defaults.
- `hosts/_user.nix` is the single source for the shared username and email; system and user declarations both import it. OpenCode remains available as a module but is disabled on both hosts.
- `hosts/<host>/user.nix` contains only the shared identity reference, that host's compatibility version and enable/settings declarations. It is discovered automatically alongside the host's other Nix files. No packaging, wrapping or application configuration implementation belongs there.
- `modules/programs/shell/` still owns terminal tools and their configuration assets.
- Paths containing `/_` are private helpers and skipped by `import-tree`.
- `overlays/` holds system package overlays; `flake/overlays.nix` only registers them.
- `hosts/<name>/hardware.nix` owns generated hardware configuration; `machine.nix` owns curated machine facts.
- Profiles default to disabled and are selected explicitly by hosts. Their selections use `lib.mkDefault`, so hosts can override individual capabilities without `lib.mkForce`.
- `modules/infra/base.nix` owns the shared latest-kernel policy as an overridable default; `common.nix` only supplies common tools and shell support.

## Declaration naming

- `repo.userEnvironments` is the collection of host-specific user environments.
- `hosts/<host>/user.nix` declares the whole user environment, not just application packages.
- `repo.infra.desktopSettings` groups user appearance and default-application settings.
- User-side `niri.config.enable` / `hyprland.config.enable` manage configuration; the system-side `enable` installs and integrates the compositor.
- User-side `dms.userService.enable` manages the user service.
- User-side `fcitx5.setting.enable` manages settings/theme assets; system-side `fcitx5.enable` enables the input method itself.
- Collection names remain plural (`userEnvironments`, `homeModules`, `desktopSettings`); a single capability uses `config`, `setting` or `userService`.

## Independent dependency pins

| Inputs | Owner |
| --- | --- |
| `nixpkgs-system`, `nixpkgs-system-unstable`, `dms`, `disko` | System / desktop infrastructure |
| `flake-parts`, `import-tree` | Shared Flake tooling, maintained by `update --system` |
| `nixpkgs-user`, `nixpkgs-user-unstable`, `home-manager`, `pi` | User environment |

`nixpkgs-user` follows the same release series as Home Manager; its unstable overlay uses `nixpkgs-user-unstable`, **not** the system's unstable input. Initial package pins are preserved; migration does not upgrade the package sets.

Some desktop user configuration intentionally references system-pinned components: the DMS user service uses the system's DMS input, and the Niri screenshot helper uses the system's Niri version.

## Build and validate (no activation)

```bash
nix flake check
nixos-rebuild build --flake .#desktop
nix build '.#homeConfigurations."oldflag@desktop".activationPackage' \
  --out-link result-home-desktop
```

Flake checks include the standalone environments for both `desktop` and `minisforum`.

Format edited Nix files with `nixfmt`. Stage new files before flake evaluation.

## First migration on desktop

Build **both** environments before switching. Keep the current terminal open through both activations:

```bash
nixos-rebuild build --flake .#desktop
nix build '.#homeConfigurations."oldflag@desktop".activationPackage' \
  --out-link result-home-desktop

# Remove the old system-managed Home Manager service and user package profile.
sudo nixos-rebuild switch --flake .#desktop

# Activate the already-built user environment as your normal user, not root.
./result-home-desktop/activate
```

Do not log out between the last two commands: after the system switch, the old `/etc/profiles/per-user/oldflag` package paths are gone until the standalone profile is installed. After both succeed, log out and back in to refresh PATH, session variables, desktop menus and the user service environment.

The application/configuration locations under `~/.config`, `~/.pi`, etc. do not change. The user package profile becomes `~/.nix-profile`. Existing Home Manager-managed symlinks are reused/replaced by normal Home Manager activation; do not manually delete configuration directories. If packages independently installed in the user profile conflict, inspect `nix profile list` and remove only the conflicting entries.

Use the corresponding `oldflag@minisforum` output when migrating that machine.

## Daily user updates

Update only user dependencies, then activate only the user environment:

```bash
# Pi only
nix flake update pi
home-manager switch --flake .#oldflag@desktop

# All user application / shell dependencies (including Pi)
update --user && rebuild --user
```

The Shell module provides host-specific functions:

```bash
update --system        # Update system dependencies and shared Flake tooling
update --user          # Update only user dependencies
rebuild --system       # Switch the system configuration (uses sudo)
rebuild --user         # Switch user applications/configuration (without sudo)
list-gen --system      # List NixOS system generations
list-gen --user        # List Home Manager generations
```

Use `rebuild --user` after changing application selections or user configuration. All three functions support `--help`; a missing or invalid target only prints usage and returns an error. `update` requires exactly one target, works from any directory, and only changes the repository lock file: it does not build or activate anything. It rejects extra arguments so another input cannot accidentally cross the selected scope. For `rebuild` and `list-gen`, additional arguments are forwarded to the underlying command, e.g. `rebuild --user --show-trace`. The old `rebuild-sys` / `rebuild-user` aliases are removed.

Command dispatch, update scopes, quoting and error handling are tested during the user environment build using stubs; the tests never update inputs or switch configurations.

Avoid an unrestricted `nix flake update` for routine application updates: it also advances system inputs. Updating an entire application nixpkgs snapshot can still change many **user** dependencies; independent deployment does not eliminate those builds.

## System updates

```bash
update --system && rebuild --system
```

If a system update changes DMS or Niri, also run `rebuild --user` so the dependent user service/helper stays aligned. A compositor change may require a new login session.

## Rollback

System and Home Manager generations are independent:

```bash
sudo nixos-rebuild switch --rollback
home-manager generations
```

To restore a user generation, run the chosen generation's `activate` script as your normal user. Do not roll back into an old **integrated** Home Manager system while leaving standalone activation active; restore a compatible pair so there is only one configuration owner.

## Adding applications

1. Add/extend the owning file under `modules/programs/`.
2. Export a `flake.homeModules.<name>` module with a `repo.programs.<name>.enable` option.
3. Enable it in the target host's `hosts/<host>/user.nix`.
4. Keep wrapping logic, settings and assets in the owning module (private Nix helpers under `/_`).
5. Add system integration, if genuinely needed, via a `flake.nixosModules.<name>` export and enable it in the appropriate host/profile.

Do not introduce a second home directory tree or collect application implementation in the declaration file.
