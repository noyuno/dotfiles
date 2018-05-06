# dotfiles

:penguin: Environment structure tool, config, scripts, templates.


- [aliases](https://github.com/noyuno/dotfiles/blob/master/readme-aliases.md)
- [日本語](https://github.com/noyuno/dotfiles/blob/master/readme-ja.md)
- [Raspberry Pi](https://github.com/noyuno/dotfiles/blob/master/raspberry-pi/readme.md)

## Requirements

- Arch Linux or Ubuntu 17.10 based distribution
- `sudo`
- `bash`
- `git`
- This repo (Please change owner by `dfchuri` (hosting URI, user name and so on))

## Using this repository

1. Fork
2. `git clone https://github.com/user/dotfiles.git ~/dotfiles`
3. `git remote set-url origin <your-url>`
4. `dfchuri`
5. `git add . && git commit -m Update && git push origin master`
6. [run install/deploy commands](https://github.com/noyuno/dotfiles/blob/master/readme-arch.md#commands)
7. As you like

## Distributions

### Arch Linux

- [Arch Linux (English)](https://github.com/noyuno/dotfiles/blob/master/readme-arch.md)
- [Arch Linux (日本語)](https://github.com/noyuno/dotfiles/blob/master/readme-arch-ja.md)

### Ubuntu

- [Ubuntu (English)](https://github.com/noyuno/dotfiles/blob/master/readme-ubuntu.md)
- [Ubuntu (日本語)](https://github.com/noyuno/dotfiles/blob/master/readme-ubuntu-ja.md)

It is outdated. I recommend the Arch Linux.

## Preferences

- Running these commands will install **NON-FREE SOFTWARES**.
- MATE Desktop
- Font: Inconsolata/Noto Sans CJK JP DemiLight
- Typesetting: TeX Live 2017, upLaTeX: Latexmk(pdfdvi), Markdown: Pandoc

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
- [`backup`](https://noyuno.github.io/blog/2018-03-17-snapshot): Take an snapshot $HOME directory.
- [`blog`](https://noyuno.github.io/2018-04-28-blog): Write blog articles.
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
- [`jma`](https://noyuno.github.io/blog/2017/10/08/jma): Show JMA disaster report.
- `kernel`: Get and build kernel.
- `mate-terminal-colorscheme-hybrid`: Make mate-terminal colorscheme to hybrid. Called by `dfguiconf`.
- [`menu`](https://noyuno.github.io/blog/2017/08/11/application-menu-on-cli/): Program menu.
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
- `upgrade`: Upgrade installed apt packages.
- `weather`: Show weather forecast.

## Figures

![fig](https://raw.githubusercontent.com/noyuno/dotfiles/master/fig/fig.png)

    tmain (tmuxinator)

## References
- Vim/Neovim: [Shougo/shougo-s-github](https://github.com/Shougo/shougo-s-github)

