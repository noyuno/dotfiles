(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
(el-get 'sync)

(el-get-bundle auto-complete)
(el-get-bundle git-commit-mode)
(el-get-bundle dash)
(el-get-bundle with-editor)
(el-get-bundle magit)
(load "~/.emacs.d/el-get/magit/lisp/git-commit")
(el-get-bundle popup)
(el-get-bundle s)
(el-get-bundle helm)
(el-get-bundle flycheck)
(el-get-bundle undo-tree)
(el-get-bundle pkg-info)
(el-get-bundle markdown-mode)
(custom-set-variables
 '(markdown-command "/usr/bin/pandoc"))
(el-get-bundle auctex-latexmk)
;;
;; AUCTeX
;;
(with-eval-after-load 'tex
  (defun TeX-evince-sync-view ()
    (require 'url-util)
    (let* ((uri (concat "file://" (url-encode-url
                                   (expand-file-name
                                   (concat file "." "pdf")))))
           (owner (dbus-call-method
                   :session "org.gnome.evince.Daemon"
                   "/org/gnome/evince/Daemon"
                   "org.gnome.evince.Daemon"
                   "FindDocument"
                   uri
                   t)))
      (if owner
          (with-current-buffer (or (when TeX-current-process-region-p
                                     (get-file-buffer (TeX-region-file t)))
                                   (current-buffer))
            (sleep-for 0.2)
            (dbus-call-method
             :session owner
             "/org/gnome/evince/Window/0"
             "org.gnome.evince.Window"
             "SyncView"
             (buffer-file-name)
             (list :struct :int32 (line-number-at-pos) :int32 (1+ (current-column)))
             :uint32 0))
        (error "Couldn't find the Evince instance for %s" uri)))))
(with-eval-after-load 'tex-jp
  (setq TeX-engine-alist '((pdfuptex "pdfupTeX"
                                     "ptex2pdf -u -e -ot '%S %(mode)'"
                                     "ptex2pdf -u -l -ot '%S %(mode)'"
                                     "euptex")))
  (setq japanese-TeX-engine-default 'pdfuptex)
  ;(setq japanese-TeX-engine-default 'luatex)
  ;(setq japanese-TeX-engine-default 'xetex)
  (setq TeX-view-program-selection '((output-dvi "Evince")
                                     (output-pdf "Evince")))
  ;(setq TeX-view-program-selection '((output-dvi "Okular")
  ;                                   (output-pdf "Okular")))
  (setq japanese-LaTeX-default-style "bxjsarticle")
  ;(setq japanese-LaTeX-default-style "ltjsarticle")
  (dolist (command '("pTeX" "pLaTeX" "pBibTeX" "jTeX" "jLaTeX" "jBibTeX" "Mendex"))
    (delq (assoc command TeX-command-list) TeX-command-list)))
(setq preview-image-type 'dvipng)
(setq TeX-source-correlate-method 'synctex)
(setq TeX-source-correlate-start-server t)
(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
(add-hook 'LaTeX-mode-hook 'TeX-PDF-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook
          (function (lambda ()
                      (add-to-list 'TeX-command-list
                                   '("Latexmk"
                                     "latexmk %t"
                                     TeX-run-TeX nil (latex-mode) :help "Run Latexmk"))
                      (add-to-list 'TeX-command-list
                                   '("Latexmk-upLaTeX-pdfdvi"
                                     "latexmk -e '$latex=q/uplatex %%O %S %(mode) %%S/' -e '$bibtex=q/upbibtex %%O %%B/' -e '$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/' -e '$makeindex=q/upmendex %%O -o %%D %%S/' -e '$dvipdf=q/dvipdfmx %%O -o %%D %%S/' -norc -gg -pdfdvi %t"
                                     TeX-run-TeX nil (latex-mode) :help "Run Latexmk-upLaTeX-pdfdvi"))
		      (add-to-list 'TeX-command-list
                                   '("xdg-open"
                                     "xdg-open %s.pdf"
                                     TeX-run-discard-or-function t t :help "Run xdg-open"))
		      )))

;;
;; RefTeX with AUCTeX
;;
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)
;;
;; kinsoku.el
;;
(setq kinsoku-limit 10)

(auctex-latexmk-setup)

(el-get-bundle minimap)
(custom-set-faces
 '(minimap-active-region-background
   ((((background dark)) (:background "#2A2A2A222222"))
    (t (:background "#D3D3D3222222"))
   "Face for the active region in the minimap.
By default, this is only a different background color."
   :group 'minimap)))
(custom-set-variables '(minimap-highlight-line-color "blue"))
;;(custom-set-faces
;; '(minimap-highlight-line-color
;;   ((((background dark)) (:background "#666666222222"))
;;      (t (:background "#666666222222"))
;;      :group 'minimap)))
(el-get-bundle multiple-cursors)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-M->") 'mc/skip-to-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(el-get-bundle image+)
(el-get-bundle python)
;;(el-get-bundle jedi)
;;(jedi:setup)
;;(define-key jedi-mode-map (kbd "<C-tab>") nil) ;;C-tabはウィンドウの移動に用いる
;;(setq jedi:complete-on-dot t)
;;(setq ac-sources
;;      (delete 'ac-source-words-in-same-mode-buffers ac-sources)) ;;jediの補完候補だけでいい
;;(add-to-list 'ac-sources 'ac-source-filename)
;;(add-to-list 'ac-sources 'ac-source-jedi-direct)
;;(define-key python-mode-map "\C-ct" 'jedi:goto-definition)
;;(define-key python-mode-map "\C-cb" 'jedi:goto-definition-pop-marker)
;;(define-key python-mode-map "\C-cr" 'helm-jedi-related-names)

;; disable remove lf end of file
;;(defvar delete-trailing-whitespece-before-save t)
;;(make-variable-buffer-local 'delete-trailing-whitespece-before-save)
;;(advice-add 'delete-trailing-whitespace :before-while
;;            (lambda () delete-trailing-whitespece-before-save))
(el-get-bundle exec-path-from-shell)
(exec-path-from-shell-initialize)
(el-get-bundle fill-column-indicator)
(fci-mode)

(el-get-bundle pdf-tools)
(el-get-bundle tablist)
(add-to-list 'auto-mode-alist (cons "\\.pdf$" 'pdf-view-mode))
;;(require 'linum)
;;(global-linum-mode)
;;(defcustom linum-disabled-modes-list '(doc-view-mode pdf-view-mode)
;;  "* List of modes disabled when global linum mode is on"
;;  :type '(repeat (sexp :tag "Major mode"))
;;  :tag " Major modes where linum is disabled: "
;;  :group 'linum
;;  )
;;(defcustom linum-disable-starred-buffers 't
;;  "* Disable buffers that have stars in them like *Gnu Emacs*"
;;  :type 'boolean
;;  :group 'linum)
;;(defun linum-on ()
;;  "* When linum is running globally, disable line number in modes defined in `linum-disabled-modes-list'. Changed by linum-off. Also turns off numbering in starred modes like *scratch*"
;;  (unless (or (minibufferp) (member major-mode linum-disabled-modes-list)
;;          (and linum-disable-starred-buffers (string-match "*" (buffer-name)))
;;          )
;;    (linum-mode 1)))
;;(provide 'setup-linum)
(add-hook 'pdf-view-mode-hook
  (lambda ()
    (pdf-misc-size-indication-minor-mode)
    (pdf-links-minor-mode)
    (pdf-isearch-minor-mode)
  )
)
(pdf-tools-install)

;; Mew
(el-get-bundle mew)
;;(autoload 'mew "mew" nil t)
;;(autoload 'mew-send "mew" nil t)

;; Optional setup (Read Mail menu):
(setq read-mail-command 'mew)

;; Optional setup (e.g. C-xm for sending a message):
(autoload 'mew-user-agent-compose "mew" nil t)
(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'mew-user-agent))
(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
      'mew-user-agent
      'mew-user-agent-compose
      'mew-draft-send-message
      'mew-draft-kill
      'mew-send-hook))

(setq mew-mail-domain "gmail.com")
(setq mew-smtp-server "smtp.gmail.com")
(setq mew-smtp-port "465")
(setq mew-smtp-ssl-port "465")
(setq mew-smtp-auth  t)
(setq mew-smtp-ssl t)
(setq mew-proto "%")
(setq mew-imap-server "imap.gmail.com")
(setq mew-imap-ssl-port "993")
(setq mew-imap-auth  t)
(setq mew-imap-ssl t)
(setq mew-use-cached-passwd t)
;;(setq mew-use-master-passwd t)
;;(setq mew-ssl-verify-level 0)
(setq exec-path (cons "/usr/bin" exec-path))
(cond ((file-exists-p "~/.emacs.d/mew.gpg")
       (load-library "~/.emacs.d/mew.gpg")) nil)

(when (require 'saveplace nil t)
  (setq-default save-place t)
  (setq save-place-file "~/.emacs.d/saved-places"))
