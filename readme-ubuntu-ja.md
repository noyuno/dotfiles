# dotfiles: Ubuntu

境環構築ツール，設定ファイル，有用なスクリプト．

- [Home (日本語)](https://github.com/noyuno/dotfiles/blob/master/readme-ja.md)
- [Home (English)](https://github.com/noyuno/dotfiles/blob/master/readme.md)
- [Ubuntu (English))](https://github.com/noyuno/dotfiles/blob/master/readme-ubuntu.md)

## コマンド

以下を端末に貼り付けてください：

    curl -sL https://raw.githubusercontent.com/noyuno/dotfiles/master/bin/dfget | bash -s all

または，必要に応じて以下のコマンドのうち一つを貼り付けてください．

    git clone https://github.com:noyuno/dotfiles.git ~/dotfiles --depth 1 && ~/dotfiles/bin/dflocal all
    wget -qO - https://raw.githubusercontent.com/noyuno/dotfiles/master/bin/dfget | bash -s all
    curl -sL https://raw.githubusercontent.com/noyuno/dotfiles/master/bin/dfget | bash -s ssh all
    wget -qO - https://raw.githubusercontent.com/noyuno/dotfiles/master/bin/dfget | bash -s ssh all

- `dflocal`: `~/dotfiles/ubuntu/bin/df*`　コマンドを実行します．
- `dfget`: dotfilesリポジトリをクローンして，`dflocal`を実行します．

### 引数

`dflocal`, `dfget` は以下のセットまたは要素から少なくともひとつの引数が必要です．
依存する要素は前に置かなければなりません．

| 要素 \ セット  | `all` | `cli` | 依存           | 説明                      |
| :------------: | :---: | :---: | :------------: | :-----------------------: |
| `dfinstall   ` | v     | v     |                | CLI基底パッケージをインストールする． |
| `dfguiinstall` | v     |       | `dfinstall   ` | MATE GUI環境をインストールする． |
| `dfsysconf   ` | v     | v     | `dfinstall   ` | システムの設定をする． |
| `dfdeploy    ` | v     | v     | `dfinstall   ` | `ln`でdotfilesを展開する．|
| `dfguiconf   ` | v     |       | `dfdeploy    ` | ユーザ環境下のGUIを設定する．|
| `dfnvim-apt  ` | v     | v     | `dfdeploy    ` | NeovimをAPTからインストールする．|
| `dfnvim-build` |       |       | `dfdeploy    ` | Neovimをソースからインストールする．|
| `dfvim       ` |       |       | `dfdeploy    ` | Vimをソースからインストールする．|
| `dfemacs     ` |       |       | `dfdeploy    ` | Emacsをインストールする．|
| `dfjava      ` | v     |       | `dfguiinstall` | Eclipseをインストールする．|
| `dftex       ` | v     |       | `dfguiinstall` | TeX Liveをインストールする．|
| `dfdns       ` |       |       | `dfinstall   ` | unboundをインストールする．|
| `dfurxvt     ` |       |       | `dfinstall   ` | urxvt ターミナルをインストールする．   |
| `dfgcp       ` |       |       | `dfinstall   ` | Google Cloud Platformを設定する． |
| `dfdein      ` | v     | v     | `dfdeploy    ` | dein.vim プラグインを取得する． |

## 拡張設定ツール

- `dfchuri`: dotfilesの所有者情報を変更する（ホスティングURI，ユーザ名など）
- `dfdocker`: dotfiles docker ツール．
- `dfdoctor`: パッケージおよび展開の診断ツール．
- `dffunc`: 基底関数．
- `dfvim-alternatives`: Vim/Neovimのalternativesを設定する．
- `dfpassword`: RSAおよびGPG鍵を設定する．
- `dfreadme-bin`: `readme.md`で説明されていないコマンドを表示する．
- `dfstopservice`: 不必要なサービスを止める．

### 環境変数

- `DRYRUN`
- `QUIET`

### インストール後

- Vim/Neovimを実行して`:UpdateRemotePlugins`を入力して，エディタを再起動してください．

## 図

![fig](https://raw.githubusercontent.com/noyuno/dotfiles/master/fig/fig.png)

上段: anime，中段: ical，下段左: jma, 下段右: weather．
`tmain (tmuxinator)`で見た目が整います．

