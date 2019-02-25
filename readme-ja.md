# dotfiles

:penguin: 境環構築ツール，設定，スクリプト，テンプレート．

- [aliases](https://github.com/noyuno/dotfiles/blob/master/readme-aliases.md)
- [English](https://github.com/noyuno/dotfiles/blob/master/readme.md)
- [Raspberry Pi](https://github.com/noyuno/dotfiles/blob/master/raspberry-pi/readme.md)

## 要件

- Arch Linux
- `apt`
- `sudo`
- `bash`
- `git`または `curl`，`wget`

## 使う

1. フォーク
2. `git clone https://github.com/user/dotfiles.git ~/dotfiles`
3. `git remote set-url origin <your-url>`
4. [インストール/展開コマンドを実行する](https://github.com/noyuno/dotfiles/blob/master/readme-arch-ja.md#コマンド)

## ディストリビューション

### Arch Linux

- [Arch Linux (English)](https://github.com/noyuno/dotfiles/blob/master/readme-arch.md)

### Windows 10 1803

- Chocolatey
- `windows/dfinstall.ps1`: Install applications in `windows/packages.config`

## 外観

- これらのコマンドを実行すると**不自由なソフトウェア**がインストールされます．
- MATE Desktop
    - コントロール:Equilux
    - ウィンドウの境界:Equilux
    - アイコン:MATE-Faenza-Dark
    - ポインタ:MATE
- フォント: Inconsolata/Noto Sans CJK JP DemiLight
- 組版: TeX Live 2015, upLaTeX: Latexmk(pdfdvi), Markdown: Pandoc

| アプリケーション | カラースキーム | ステータスライン | 実行 | 入力メソッド | 推奨 |
|:-------------:|:-----------:|:----------:|:----:|:----------:|:-----------:|
| MATE-terminal | hybrid      |            | tmux | Fcitx-Mozc | v           |
| Neovim        | hybrid      | lightline  |      |            | v           |
| tmux          | Solarized   |            | Zsh  |            | v           |
| Zsh           |             |            |      |            | v           |
| Emacs (spacemacs) |             |            |      |            | v           |
| VSCode        |             |            |      |            | v           |

## 有用なコマンド

- `anime-check`: このシーズンで設定されたアニメが放送されるか確認する．
- [`anime`](https://noyuno.github.io/2016-12-09-anime): アニメ番組表を表示する．
- `args`: 引数チェッカ．
- `background`: 壁紙を同期する．
- `backlight`: Intelバックライトの明るさを変更する．
- [`backup`](https://noyuno.github.io/blog/2018-03-17-snapshot): $HOME ディレクトリのスナップショットを取る．
- [`blog`](https://noyuno.github.io/2018-04-28-blog): ブログの執筆をする.
- [`board`](https://noyuno.github.io/2017-01-01-board): ターミナルに電光掲示板のように表示する．
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
- [`printout`](https://noyuno.github.io/blog/2017-05-15-printout): ファイルまたは標準入力からの平文テキストを印刷する.
- `pull`: ホームディレクトリ下のリポジトリをpullする.
- [`repo`](https://noyuno.github.io/blog/2017-06-25-repo): 自分のリポジトリを更新する.
- `rinit`: レポート作成用ディレクトリを作成する.
- `rmswap`: Vim/Neovim スワップファイルをZsh補完候補から選択して削除する.
- `start-offlineimap`: `offlineimap`デーモンを開始する.
- `today`: 今日の単語とその意味.
- `unicode`: ユニコード名を表示する.
- `weather`: 天気予報を表示する.

## スクリーンショット

![fig](https://raw.githubusercontent.com/noyuno/dotfiles/master/fig/fig.png)

上段: anime，中段: ical，下段左: jma, 下段右: weather．

`tmain (tmuxinator)`で見た目が整います．

## 参考
- Vim/Neovim: [Shougo/shougo-s-github](https://github.com/Shougo/shougo-s-github)

