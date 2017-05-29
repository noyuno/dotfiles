# dotfiles

## Requirements

- Ubuntu based distribution
- `apt`
- `sudo`
- `bash`
- `git` or `curl` or `wget`
- This repo (`dfchuri` to change hosting uri, and user name and so on)

## Commands

    git clone git@github.com:noyuno/dotfiles.git ~/dotfiles --depth 1 && ~/dotfiles/bin/dflocal all
    curl -sL https://raw.githubusercontent.com/noyuno/dotfiles/master/bin/dfhttps | bash -s all
    wget -qO - https://raw.githubusercontent.com/noyuno/dotfiles/master/bin/dfhttps | bash -s all

- `dflocal`: Install from local Git directory.
- `dfssh`: Clone remote Git repository via SSH. (Requires adding public key to
CVS.)
- `dfhttps`: Clone remote Git repository via HTTPS. (Requires typing CVS' user
id and password.)

### Arguments

`dflocal`, `dfssh`, `dfhttps` require least 1 argument of below set/item.
Depending items have to put before install item.

| item   \ set   | `all` | `cli` | depends        | description               |
| :------------: | :---: | :---: | :------------: | :-----------------------: |
| `dfinstall   ` | v     | v     |                | Install CLI base package. |
| `dfguiinstall` | v     |       | `dfinstall   ` | Install MATE GUI package. |
| `dfsysconf   ` | v     | v     | `dfinstall   ` | Configure system.         |
| `dfdeploy    ` | v     | v     | `dfinstall   ` | Deploy dotfiles using ln. |
| `dfguiconf   ` | v     |       | `dfdeploy    ` | Configure user GUI.       |
| `dfnvim      ` | v     | v     | `dfdeploy    ` | Install Neovim.           |
| `dfemacs     ` |       |       | `dfdeploy    ` | Install Emacs.            |
| `dfvim       ` |       |       | `dfdeploy    ` | Install Vim               |
| `dfjava      ` | v     |       | `dfguiinstall` | Install Eclipse           |
| `dftex       ` | v     |       | `dfguiinstall` | Install TeX Live.         |

### Environment variables

- `DRYRUN`
- `QUIET`

### Extra commands

- `anime`: Display anime program list.
- `args`: Arguments checker.
- `backlight`: Change intel backlght brightness.
- `blog`: Create blog post.
- `board`: Show as electric bulletin board.
- `color`: 256-color terminal tester.
- `dfchuri`: Change dotfiles hosting URI
- `dfdocker`: dotfiles docker tool.
- `dfdoctor`: Packages and deployments checker.
- `dffunc`: Base function.
- `dfgetdf`: An Internal function cloning dotfiles.
- `dfnvim-alternatives`, `dfvim-alternatives`: `update-alternatives` set up alternatives of Vim/Neovim.
- `dfpassword`: Set up RSA and GPG keys.
- `dfstopservice`: Stop unnecessary service.
- `extension`: Get file extension using MIME.
- `gitignore`: Remove git-watching files registered in `.gitignore`.
- `gitsnapshot`: Take an snapshot of this git repository.
- `google`: Search web.
- `holiday`: Show holiday.
- `ical`: Print ical calendar.
- `image`: Show image via terminal
- `jma`: Show JMA disaster report.
- `kernel`: Get and build kernel.
- `mate-terminal-colorscheme-hybrid`: Make mate-terminal colorscheme to hybrid. Called by `dfguiconf`.
- `menu`: Program menu.
- `netload`: Measure network interface load.
- `news`: Show news.
- `note`: Take a note.
- `now` : Show current time.
- `panview`: View as HTML using Pandoc.
- `pi`: Raspberry Pi 3 command.
- `printout`: Print out plain text file or stdin.
- `pull`: Pull under all $HOME repository.
- `rate`: Show JPY/USD rate.
- `repo`: Synchronize my GitHub/Bitbucket repositories.
- `rinit`: Initialize report directory.
- `rmdocker`: Remove unnamed containers and images.
- `rmswap`: Remove Vim/Neovim swap file using zsh completion candidates.
- `today`: Today's word and its meaning.
- `unicode`: Show unicode name.
- `upgrade`: Upgrade installed packages.
- `weather`: Show weather forecast.

### After installation

- Execute Vim/Neovim, type `:call dein#install()`, `:UpdateRemotePlugins` and
restart it.

## Preferences

- Ubuntu MATE Desktop 16.04.1 LTS
- Font: Inconsolata for Powerline/Noto Sans CJK JP DemiLight
- Typesetting: TeX Live 2015, upLaTeX: Latexmk(pdfdvi), Markdown: Pandoc

| applications  | colorscheme | statusline | run  | IM         | recommended |
|:-------------:|:-----------:|:----------:|:----:|:----------:|:-----------:|
| MATE-terminal | hybrid      |            | tmux | Fcitx-Mozc | v           |
| rxvt-unicode  | hybrid      |            | tmux | Fcitx-Mozc |             |
| UXTerm        | hybrid      |            | tmux | -          |             |
| Vim           | hybrid      | lightline  |      |            |             |
| Neovim        | hybrid      | lightline  |      |            | v           |
| tmux          | Solarized   |            | Zsh  |            | v           |
| Zsh           |             |            |      |            | v           |
| Bash          |             |            |      |            |             |
| Emacs         | Wombat      |            |      |            |             |

## Automatic partition tool

On the live DVD, before install operation:

    sudo su -
    wget https://raw.githubusercontent.com/noyuno/dotfiles/master/autoinstall/install.sh
    bash install.sh /dev/sda 20G # root partition size

After install operation:

    bash install.sh luks /dev/sdb1 # usb

Partitioning will be:

    | sda1      | sda2             | sda3    |
    |           | lvm(vg0)         | bios    |
    |           | lv0   | lv1      |         |
    |           |       | luks     |         |
    | fat32     | ext4  | ext4     | ef02    |
    | /boot/efi | /     | /home    |         |
    | 100MB     | 100GB | 100%free | 1007KiB |

## Windows 10 1607

- Chocolatey
- `runvbox.ps1`: Run Ubuntu on VirtualBox on Windows.
- `windows/dfinstall.ps1`, `windows/dfdeploy.ps1`: For Windows Subsystem for Linux.

## Figures

![fig](https://raw.githubusercontent.com/noyuno/dotfiles/master/fig/fig.png)

## References
- Vim/Neovim: [Shougo/shougo-s-github](https://github.com/Shougo/shougo-s-github)

