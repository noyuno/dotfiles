# dotfiles

Environment structure tool, config files, practical scripts.

[aliases](https://github.com/noyuno/dotfiles/blob/master/readme-aliases.md)
[日本語](https://github.com/noyuno/dotfiles/blob/master/readme-ja.md)
[Raspberry Pi](https://github.com/noyuno/dotfiles/blob/master/raspberry-pi/readme.md)

## Requirements

- Ubuntu based distribution
- `apt`
- `sudo`
- `bash`
- `git` or `curl` or `wget`
- This repo (Please change owner by `dfchuri` (hosting URI, user name and so on))

## Using this repository

1. Fork
2. `git clone https://github.com/user/dotfiles.git ~/dotfiles`
3. `dfchuri`
4. `git add . && git commit -m Update && git push origin master`
5. `./dotfiles/bin/dfinstall`
6. `./dotfiles/bin/dfdeploy`
7. As you like

## Commands

Paste on terminal:

    curl -sL https://raw.githubusercontent.com/noyuno/dotfiles/master/bin/dfget | bash -s all

Or, paste one of the following commands if necessary.

    git clone git@github.com:noyuno/dotfiles.git ~/dotfiles --depth 1 && ~/dotfiles/bin/dflocal all
    wget -qO - https://raw.githubusercontent.com/noyuno/dotfiles/master/bin/dfget | bash -s all
    curl -sL https://raw.githubusercontent.com/noyuno/dotfiles/master/bin/dfget | bash -s ssh all
    wget -qO - https://raw.githubusercontent.com/noyuno/dotfiles/master/bin/dfget | bash -s ssh all

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

## Useful commands

- `anime-check`: Check whether onair the anime this season.
- [`anime`](https://noyuno.github.io/blog/2016/12/09/anime/): Display anime program list.
- `args`: Arguments checker.
- `background`: Synchronize background wallpaper.
- `backlight`: Change intel backlght brightness.
- `blog`: Create blog post.
- [`board`](https://noyuno.github.io/blog/2017/01/01/board/): Show the terminal as electric bulletin board.
- `color`: 256-color terminal tester.
- `dconf-dump`: Dump dconf.
- `dumppass`: Dump password from `password-store`.
- `dumprepo`: Dump home repositories as json.
- `extension`: Get file extension using MIME.
- `getpackage`: Print packages that installed by apt.
- `git-gc-all`: Collect Git garbage objects in all repositories.
- `gitignore`: Remove git-watching files registered in `.gitignore`.
- `google`: Search web.
- `hardware`: Show hardware information.
- `holiday`: Show holiday.
- `ical`: Print ical calendar.
- `idea`: Launch IntelliJ IDEA.
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
- [`pi`](https://github.com/noyuno/dotfiles/blob/master/raspberry-pi/readme.md): Raspberry Pi 3 command.
- [`printout`](https://noyuno.github.io/blog/2017/05/15/printout/): Print out plain text from file or stdin.
- `pull`: Pull under all $HOME repository.
- `rate`: Show JPY/USD rate.
- [`repo`](https://noyuno.github.io/blog/2017/06/25/repo/): Synchronize my repositories.
- `rinit`: Initialize report directory.
- `rmdocker`: Remove unnamed containers and images.
- `rmswap`: Remove Vim/Neovim swap file using zsh completion candidates.
- `start-offlineimap`: Start `offlineimap` daemon.
- `today`: Today's word and its meaning.
- `unicode`: Show unicode name.
- `upgrade`: Upgrade installed packages.
- `weather`: Show weather forecast.

## [Automatic partition tool](https://noyuno.github.io/blog/2017/04/09/crypto/)

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

    tmain

## References
- Vim/Neovim: [Shougo/shougo-s-github](https://github.com/Shougo/shougo-s-github)

