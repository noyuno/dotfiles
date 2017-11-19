# dotfiles

境環構築ツール，設定ファイル，有用なスクリプト．

- [aliases](https://github.com/noyuno/dotfiles/blob/master/readme-aliases.md)
- [English](https://github.com/noyuno/dotfiles/blob/master/readme.md)
- [Raspberry Pi](https://github.com/noyuno/dotfiles/blob/master/raspberry-pi/readme.md)

## 要件

- Ubuntuベースのディストリビューション
- `apt`
- `sudo`
- `bash`
- `git`または `curl`，`wget`
- このリポジトリ（`dfchuri`で所有者（ホスティングURI，ユーザ名など）を変更してから使ってください）

## 使う

1. フォーク
2. `git clone https://github.com/user/dotfiles.git ~/dotfiles`
3. `git remote set-url origin <your-url>`
4. `dfchuri`
5. `git add . && git commit -m Update && git push origin master`
6. `./dotfiles/bin/dfinstall`
7. `./dotfiles/bin/dfdeploy`
8. お好きに

## 始める

    git clone https://github.com:noyuno/dotfiles.git ~/dotfiles

## ディストリビューション


### Arch Linux

- [Arch Linux (English)](https://github.com/noyuno/dotfiles/blob/master/readme-arch.md)
- [Arch Linux (日本語)](https://github.com/noyuno/dotfiles/blob/master/readme-arch-ja.md)

### Ubuntu

- [Ubuntu (English)](https://github.com/noyuno/dotfiles/blob/master/readme-ubuntu.md)
- [Ubuntu (日本語)](https://github.com/noyuno/dotfiles/blob/master/readme-ubuntu-ja.md)

## 外観

- これらのコマンドを実行すると**不自由なソフトウェア**がインストールされます．
- MATE Desktop
- フォント: Inconsolata/Noto Sans CJK JP DemiLight
- 組版: TeX Live 2015, upLaTeX: Latexmk(pdfdvi), Markdown: Pandoc

| アプリケーション | カラースキーム | ステータスライン | 実行 | 入力メソッド | 推奨 |
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

## 有用なコマンド

- `anime-check`: このシーズンで設定されたアニメが放送されるか確認する．
- [`anime`](https://noyuno.github.io/blog/2016/12/09/anime/): アニメ番組表を表示する．
- `args`: 引数チェッカ．
- `background`: 壁紙を同期する．
- `backlight`: Intelバックライトの明るさを変更する．
- `blog`: ブログの投稿を作成する．
- [`board`](https://noyuno.github.io/blog/2017/01/01/board/): ターミナルに電光掲示板のように表示する．
- `color`: 256-color端末テスタ．
- `dconf-dump`: dconfダンパ.
- `dumppass`: `password-store`のパスワードをダンプ.
- `dumprepo`: ホームディレクトリ下のリポジトリをJSONで出力する.
- `extension`: MIMEを用いて拡張子を取得する.
- `getpackage`: APTでインストールされたパッケージを表示する．
- `git-gc-all`: すべてのGitリポジトリのガーベージコレクションを実行する.
- `gitignore`: `.gitignore`で登録されているファイルを削除する.
- `google`: Webを検索する.
- `hardware`: ハードウェア情報を表示する.
- `holiday`: 祝日を表示する.
- `ical`: ical形式カレンダーを表示する.
- `idea`: IntelliJ IDEAを起動する.
- `image`: 端末内で画像を閲覧する．
- `jma`: 気象庁防災情報を表示する.
- `kernel`: カーネルを取得，ビルドする.
- `mate-terminal-colorscheme-hybrid`: mate-terminalのカラースキームをhybridにする. `dfguiconf`で呼び出される.
- `menu`: プログラムメニュー.
- `netload`: ネットワーク負荷を計測する.
- `news`: ニュースを表示する.
- `note`: メモを取る.
- `now` : 現在時刻を表示する.
- `panview`: Pandocを用いてHTMLとして閲覧する.
- `pi`: Raspberry Pi 3用の設定および環境構築コマンド.
- [`printout`](https://noyuno.github.io/blog/2017/05/15/printout/): ファイルまたは標準入力からの平文テキストを印刷する.
- `pull`: ホームディレクトリ下のリポジトリをpullする.
- `rate`: JPY/USD為替レートをグラフで表示する.
- [`repo`](https://noyuno.github.io/blog/2017/06/25/repo/): 自分のリポジトリを更新する.
- `rinit`: レポート作成用ディレクトリを作成する.
- `rmdocker`: 名前がつけられていないdockerイメージおよびコンテナを削除する.
- `rmswap`: Vim/Neovim スワップファイルをZsh補完候補から選択して削除する.
- `start-offlineimap`: `offlineimap`デーモンを開始する.
- `today`: 今日の単語とその意味.
- `unicode`: ユニコード名を表示する.
- `upgrade`: インストールされたパッケージを更新する.
- `weather`: 天気予報を表示する.

## [自動パーティションツール(不安定)](https://noyuno.github.io/blog/2017/04/09/crypto/)

実行すると/dev/sdaおよび/dev/sdb1のデータが失われます．

ライブDVD上でインストール処理の前に：

    sudo su -
    wget https://raw.githubusercontent.com/noyuno/dotfiles/master/autoinstall/install.sh
    bash install.sh /dev/sda 20G # root partition size

インストール処理の後に：

    bash install.sh luks /dev/sdb1 # usb

パーティションは：

    | sda1      | sda2             | sda3    |
    |           | lvm(vg0)         | bios    |
    |           | lv0   | lv1      |         |
    |           |       | luks     |         |
    | fat32     | ext4  | ext4     | ef02    |
    | /boot/efi | /     | /home    |         |
    | 100MB     | 100GB | 100%free | 1007KiB |

## Windows 10 1607

- Chocolatey
- `runvbox.ps1`: Windows上のVirtualBox上のUbuntuを実行する．
- `windows/dfinstall.ps1`, `windows/dfdeploy.ps1`: Windows Subsystem for Linuxのためのツール．

## 図

![fig](https://raw.githubusercontent.com/noyuno/dotfiles/master/fig/fig.png)

上段: anime，中段: ical，下段左: jma, 下段右: weather．
`tmain (tmuxinator)`で見た目が整います．

## 参考
- Vim/Neovim: [Shougo/shougo-s-github](https://github.com/Shougo/shougo-s-github)

