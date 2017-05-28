;; バックアップファイルを作成させない
(setq make-backup-files nil)

;; 終了時にオートセーブファイルを削除する
(setq delete-auto-save-files t)

;; 保存前に自動でクリーンアップ
;(setq whitespace-action '(auto-cleanup))

;; 指定行にジャンプする
(global-set-key "\C-xj" 'goto-line)

;;; grep
(require 'grep)
(setq grep-command-before-query "grep -nH -r -e ")
(defun grep-default-command ()
  (if current-prefix-arg
      (let ((grep-command-before-target
             (concat grep-command-before-query
                     (shell-quote-argument (grep-tag-default)))))
        (cons (if buffer-file-name
                  (concat grep-command-before-target
                          " *."
                          (file-name-extension buffer-file-name))
                (concat grep-command-before-target " ."))
              (+ (length grep-command-before-target) 1)))
    (car grep-command)))
(setq grep-command (cons (concat grep-command-before-query " .")
                         (+ (length grep-command-before-query) 1)))

(setq vc-follow-symlinks t)

;;; ファイル名が重複していたらディレクトリ名を追加する
(require 'uniquify)
(setq uniqufy-buffer-name-style 'post-forward-angle-brackets)

;; for large file
(defun my-find-file-check-make-large-file-read-only-hook ()
 "If a file is over a given size, make the buffer read only."
  (when (> (buffer-size) (* 1024 1024))
    (setq buffer-read-only t)
    (buffer-disable-undo)
    (fundamental-mode)))

(add-hook 'find-file-hook 'my-find-file-check-make-large-file-read-only-hook)

(setq require-final-newline 't)

(require 'mozc)
(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")

(defun enable-input-method ()
      (interactive)
      (if current-input-method (inactivate-input-method))
      (toggle-input-method))
(defun disable-input-method ()
  (interactive)
  (inactivate-input-method))
(require 'mozc)  ; or (load-file "/path/to/mozc.el")
(setq default-input-method "japanese-mozc")
(progn ;toggle input method
  (define-key global-map [henkan] 'enable-input-method)
  (define-key global-map [hiragana-katakana] 'enable-input-method)
   (define-key global-map [muhenkan] 'disable-input-method)
  (define-key global-map [zenkaku-hankaku]
    (lambda ()
      (interactive)
      (toggle-input-method)))
  (defadvice mozc-handle-event (around intercept-keys (event))
    "Intercept keys muhenkan and zenkaku-hankaku, before passing keys to mozc-server (which the function mozc-handle-event does), to properly disable mozc-mode."
    (if (member event (list 'zenkaku-hankaku 'muhenkan))
	(progn
	  (mozc-clean-up-session)
	  (toggle-input-method))
      (progn ;(message "%s" event) ;debug
	ad-do-it)))
  (ad-activate 'mozc-handle-event))
