# dotfiles: Ubuntu

:penguin: Environment structure tool, config, scripts, templates for Ubuntu.

- [Home (English)](https://github.com/noyuno/dotfiles/blob/master/readme.md)
- [Home (日本語)](https://github.com/noyuno/dotfiles/blob/master/readme-ja.md)
- [Ubuntu (日本語)](https://github.com/noyuno/dotfiles/blob/master/readme-ubuntu-ja.md)

It is outdated. I recommend the Arch Linux.

## Commands

Execute on the terminal:

    git clone https://github.com:noyuno/dotfiles.git ~/dotfiles && ~/dotfiles/arch/bin/dflocal all

- `dflocal`: Run `~/dotfiles/ubuntu/bin/df*` commands.
- `dfget`: Clone dotfiles repository, and execute `dflocal`.

### Arguments

`dflocal`, `dfget` require least 1 argument of below set/item.
Depending items have to put before install item.

| item   \ set   | `all` | `cli` | depends        | description               |
| :------------: | :---: | :---: | :------------: | :-----------------------: |
| `dfinstall   ` | v     | v     |                | Install CLI base package. |
| `dfguiinstall` | v     |       | `dfinstall   ` | Install MATE GUI package. |
| `dfsysconf   ` | v     | v     | `dfinstall   ` | Configure system.         |
| `dfdeploy    ` | v     | v     | `dfinstall   ` | Deploy dotfiles using `ln`.|
| `dfguiconf   ` | v     |       | `dfdeploy    ` | Configure user GUI.       |
| `dfnvim-apt  ` | v     | v     | `dfdeploy    ` | Install Neovim from apt.  |
| `dfnvim-build` |       |       | `dfdeploy    ` | Install Neovim from source.|
| `dfvim       ` |       |       | `dfdeploy    ` | Install Vim from source.  |
| `dfemacs     ` |       |       | `dfdeploy    ` | Install Emacs.            |
| `dfjava      ` | v     |       | `dfguiinstall` | Install Eclipse           |
| `dftex       ` | v     |       | `dfguiinstall` | Install TeX Live.         |
| `dfdns       ` |       |       | `dfinstall   ` | Install unbound.          |
| `dfurxvt     ` |       |       | `dfinstall   ` | Install urxvt terminal.   |
| `dfgcp       ` |       |       | `dfinstall   ` | Set up Google Cloud Platform. |
| `dfdein      ` | v     | v     | `dfdeploy    ` | Get dein.vim plugins.     |

## Extra configuration tool

- `dfchuri`: Change dotfiles' owner (hosting URI, user name and so on).
- `dfdocker`: dotfiles docker tool.
- `dfdoctor`: Packages and deployments checker.
- `dffunc`: Base function.
- `dfvim-alternatives`: Set up alternatives of Vim/Neovim.
- `dfpassword`: Set up RSA and GPG keys.
- `dfreadme-bin`: Print not discribed command in `readme.md`.
- `dfstopservice`: Stop unnecessary service.

### Environment variables

- `DRYRUN`
- `QUIET`

### After installation

- Execute Vim/Neovim, type `:UpdateRemotePlugins` and restart it.

## Figures

![fig](https://raw.githubusercontent.com/noyuno/dotfiles/master/fig/fig.png)

    tmain (tmuxinator)

