# dotfiles: Arch Linux

:penguin: Environment structure tool, config, scripts, templates for Arch Linux.

- [Home (English)](https://github.com/noyuno/dotfiles/blob/master/readme.md)
- [Home (日本語)](https://github.com/noyuno/dotfiles/blob/master/readme-ja.md)

## Commands

Execute on the terminal:

    git clone https://github.com:noyuno/dotfiles.git ~/dotfiles && ~/dotfiles/arch/bin/dflocal all

- `dflocal`: Run `~/dotfiles/arch/bin/df*` commands.

### Arguments

`dflocal` require least 1 argument of below set/item.
Depending items have to put before install item.

| item   \ set   | `all` | `cli` | depends        | description               |
| :------------: | :---: | :---: | :------------: | :-----------------------: |
| `dfinstall   ` | v     | v     |                | Install CLI base package. |
| `dfguiinstall` | v     |       | `dfinstall   ` | Install MATE GUI package. |
| `dffont`       | v     |       | `dfinstall   ` | Install Noto Sans font.   |
| `dfdeploy    ` | v     | v     | `dfinstall   ` | Deploy dotfiles using `ln`.|
| `dfguiconf   ` | v     |       | `dfdeploy    ` | Configure user GUI.       |
| `dftex       ` | v     |       | `dfguiinstall` | Install TeX Live.         |
| `dfdein      ` | v     | v     | `dfdeploy    ` | Get dein.vim plugins.     |

- `dfinstall` installs [those packages](https://github.com/noyuno/dotfiles/blob/master/arch/list/dfinstall)
- `dfguiinstall` installs [those packages](https://github.com/noyuno/dotfiles/blob/master/arch/list/dfguiinstall)

### Environment variables

- `DRYRUN`
- `QUIET`

### After installation

- Execute Vim/Neovim, type `:UpdateRemotePlugins` and restart it.

## Extra configuration tool

- `dfdoctor`: Packages and deployments checker.
- `dfpassword`: Set up RSA and GPG keys.

## Figures

![fig](https://raw.githubusercontent.com/noyuno/dotfiles/master/fig/fig.png)

    tmain (tmuxinator)

