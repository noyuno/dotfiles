;; 環境を日本語、UTF-8にする
(set-locale-environment nil)
(set-language-environment "Japanese")
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

;; スタートアップメッセージを表示させない
(setq inhibit-startup-message t)

;; タブにスペースを使用する
;;(setq-default tab-width 4 indent-tabs-mode nil)

;; 改行コードを表示する
;;(setq eol-mnemonic-dos "(CRLF)")
;;(setq eol-mnemonic-mac "(CR)")
;;(setq eol-mnemonic-unix "(LF)")

;; 複数ウィンドウを禁止する
(setq ns-pop-up-frames nil)

;; 列数を表示する
(column-number-mode t)

;; 行数を表示する
(global-linum-mode t)

;; カーソルの点滅をやめる
(blink-cursor-mode 0)

;; カーソル行をハイライトする
(setq hl-line-face 'nil)
(global-hl-line-mode t)

;; 対応する括弧を光らせる
(show-paren-mode 1)

;; ウィンドウ内に収まらないときだけ、カッコ内も光らせる
;;(setq show-paren-style 'mixed)
;;(set-face-background 'show-paren-match-face "grey")
;;(set-face-foreground 'show-paren-match-face "black")

;; スペース、タブなどを可視化する
(global-whitespace-mode 1)

;; スクロールは１行ごとに
(setq scroll-conservatively 1)

;; シフト＋矢印で範囲選択
(setq pc-select-selection-keys-only t)
;(pc-selection-mode 1)

;; C-kで行全体を削除する
(setq kill-whole-line t)

;;; dired設定
(require 'dired-x)

;; "yes or no" の選択を "y or n" にする
(fset 'yes-or-no-p 'y-or-n-p)

;; beep音を消す
(defun my-bell-function ()
  (unless (memq this-command
    '(isearch-abort abort-recursive-edit exit-minibuffer
      keyboard-quit mwheel-scroll down up next-line previous-line
      backward-char forward-char))
   (ding)))
(setq ring-bell-function 'my-bell-function)

(load-theme 'wombat t)

(tool-bar-mode 0)

(require 'whitespace)
(setq whitespace-style '(face           ; faceで可視化
                         trailing       ; 行末
                         tabs           ; タブ
                         spaces         ; スペース
                         empty          ; 先頭/末尾の空行
                         space-mark     ; 表示のマッピング
                         tab-mark
                         ))

(setq whitespace-display-mappings
      '((space-mark ?\u3000 [?\u25a1])
        ;; WARNING: the mapping below has a problem.
        ;; When a TAB occupies exactly one column, it will display the
        ;; character ?\xBB at that column followed by a TAB which goes to
        ;; the next TAB column.
        ;; If this is a problem for you, please, comment the line below.
        (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))

;; スペースは全角のみを可視化
(setq whitespace-space-regexp "\\(\u3000+\\)")

(global-whitespace-mode 1)
(global-font-lock-mode t)

(defvar my/bg-color "#232323")
(set-face-attribute 'whitespace-trailing nil
                    :background my/bg-color
                    :foreground "DeepPink"
                    :underline t)
(set-face-attribute 'whitespace-tab nil
                    :background my/bg-color
                    :foreground "LightSkyBlue"
                    :underline t)
(set-face-attribute 'whitespace-space nil
                    :background my/bg-color
                    :foreground "GreenYellow"
                    :weight 'bold)
(set-face-attribute 'whitespace-empty nil
                    :background my/bg-color)

(set-default-font "Inconsolata for Powerline")
(setq-default line-spacing 2)
(cond (window-system
       (set-fontset-font (frame-parameter nil 'font)
			 'japanese-jisx0208
			 '("Noto Sans CJK JP" . "unicode-bmp")
			 )
       ))
;; audio settings
(setq ring-bell-function 'ignore)

;;; diredを便利にする
(require 'dired-x)

;;; diredから"r"でファイル名インライン編集する
(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

(defun browse-url-at-point ()
  (interactive)
  (let ((url-region (bounds-of-thing-at-point 'url)))
    (when url-region
      (browse-url (buffer-substring-no-properties (car url-region)
						  (cdr url-region))))))

(global-set-key "\C-c\C-o" 'browse-url-at-point)

; printout settings
(eval-when-compile (require 'ps-mule nil t))
(setq ps-paper-type        'a4 ;paper size
      ps-lpr-command       "lpr"
      ;ps-lpr-switches      '("-o Duplex=DuplexNoTumble")
      ps-printer-name      "DCPJ562N"   ; your printer name
      ps-multibyte-buffer  'non-latin-printer ;for printing Japanese
      ps-n-up-printing     2 ;print n-page per 1 paper

      ;; Margin
      ps-left-margin       20
      ps-right-margin      20
      ps-top-margin        20
      ps-bottom-margin     20
      ps-n-up-margin       20

      ;; Header/Footer setup
      ps-print-header      t            ;buffer name, page number, etc.
      ps-print-footer      nil          ;page number

      ;; font
      ps-font-size         '(9 . 10)
      ps-header-font-size  '(10 . 12)
      ps-header-title-font-size '(12 . 14)
      ps-header-font-family 'Helvetica    ;default
      ps-line-number-font  "Noto Sans CJK JP" ;default
      ps-line-number-font-size 6

      ;; line-number
      ps-line-number       t ; t:print line number
      ps-line-number-start 1
      ps-line-number-step  1
      )
