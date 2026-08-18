# dotfiles

Personal configuration files, managed with [GNU Stow](https://www.gnu.org/software/stow/).

Each top-level directory is a stow package that mirrors the target structure
relative to `$HOME`:

| Package | Contents |
| ------- | -------- |
| `nvim`  | Neovim config (`~/.config/nvim`), based on kickstart.nvim |
| `kitty` | Kitty terminal config (`~/.config/kitty`) |
| `zsh`   | `~/.zshrc`, `~/.zshenv`, `~/.zprofile` |
| `tmux`  | `~/.tmux.conf` and the tokyonight tmux theme |
| `git`   | `~/.gitconfig` and the global ignore file (`~/.config/git/ignore`) |

## Setup on a new machine

```sh
brew install stow
git clone git@github.com:ms007/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow */
```

`stow */` links every package; alternatively link selectively, e.g. `stow nvim zsh`.

## Adding a new tool

Create a package directory mirroring the paths relative to `$HOME`, move the
config files in, then run `stow <package>`:

```sh
mkdir -p ~/dotfiles/foo/.config/foo
mv ~/.config/foo/config.toml ~/dotfiles/foo/.config/foo/
cd ~/dotfiles && stow foo
```
