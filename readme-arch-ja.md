# dotfiles: Arch Linux

境環構築ツール，設定ファイル，有用なスクリプト．

- [Home (English)](https://github.com/noyuno/dotfiles/blob/master/readme.md)
- [Home (日本語)](https://github.com/noyuno/dotfiles/blob/master/readme-ja.md)
- [Arch Linux (English)](https://github.com/noyuno/dotfiles/blob/master/readme-arch.md)

## コマンド

以下を端末で実行してください：

    git clone https://github.com:noyuno/dotfiles.git ~/dotfiles && ~/dotfiles/arch/bin/dflocal all

### 引数

`dflocal`, `dfget` は以下のセットまたは要素から少なくともひとつの引数が必要です．
依存する要素は前に置かなければなりません．

| 要素 \ セット  | `all` | `cli` | 依存           | 説明                      |
| :------------: | :---: | :---: | :------------: | :-----------------------: |
| `dfinstall   ` | v     | v     |                | CLI基底パッケージをインストールする． |
| `dfguiinstall` | v     |       | `dfinstall   ` | MATE GUI環境をインストールする． |
| `dffont`       | v     |       | `dfinstall   ` | Noto Sans フォントをインストールする. |
| `dfdeploy    ` | v     | v     | `dfinstall   ` | `ln`でdotfilesを展開する．|
| `dfguiconf   ` | v     |       | `dfdeploy    ` | ユーザ環境下のGUIを設定する．|
| `dftex       ` | v     |       | `dfguiinstall` | TeX Liveをインストールする．|
| `dfdein      ` | v     | v     | `dfdeploy    ` | dein.vim プラグインを取得する． |

## 拡張設定ツール

- `dfchuri`: dotfilesの所有者情報を変更する（ホスティングURI，ユーザ名など）
- `dfdocker`: dotfiles docker ツール．
- `dfdoctor`: パッケージおよび展開の診断ツール．
- `dffunc`: 基底関数．
- `dfpassword`: RSAおよびGPG鍵を設定する．
- `dfreadme-bin`: `readme.md`で説明されていないコマンドを表示する．

### 環境変数

- `DRYRUN`
- `QUIET`

### インストール後

- Vim/Neovimを実行して`:UpdateRemotePlugins`を入力して，エディタを再起動してください．

## 図

![fig](https://raw.githubusercontent.com/noyuno/dotfiles/master/fig/fig.png)

上段: anime，中段: ical，下段左: jma, 下段右: weather．
`tmain (tmuxinator)`で見た目が整います．

