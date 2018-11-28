
;; init.el --- Emacs configuration

;; SETUP
;; --------------------------------------


(server-start)
(require 'package)

;; (package-initialize)


;; package sources
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
;; (setq package-enable-at-startup nil)


;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq use-package-always-ensure t)

;; setup benchmark
(use-package benchmark-init
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))

(add-hook 'after-init-hook
          (lambda () (message "loaded in %s" (emacs-init-time))))


;; quickly find this file
;; (defun find-config ()
;;   "Edit config.org"
;;   (interactive)
;;   (find-file "~/emacs.d/init.el"))

(global-set-key (kbd "C-c I") 'find-config)





;; This stops emacs adding customised settings to init.el
(setq custom-file (make-temp-file "emacs-custom"))



;; centralize backup files to prevent dirspace clutter
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
  backup-by-copying t    ; Don't delink hardlinks
  version-control t      ; Use version numbers on backups
  delete-old-versions t  ; Automatically delete excess backups
  kept-new-versions 20   ; how many of the newest versions to keep
  kept-old-versions 5    ; and how many of the old
  )


;; stop trust theme prompt
(setq custom-safe-themes t)

;; save and restore desktop
(use-package desktop
	:config
	(desktop-save-mode 1))

;; .zsh file is shell script too
(add-to-list 'auto-mode-alist '("\\.zsh\\'" . shell-script-mode))


;; EDITOR
;; --------------------

;; (setq inhibit-startup-message t)

;; reload on external changes
(global-auto-revert-mode t)

;; don't use tabs
(setq-default indent-tabs-mode nil)

(global-set-key (kbd "s-[") 'indent-rigidly-left-to-tab-stop)
(global-set-key (kbd "s-]") 'indent-rigidly-right-to-tab-stop)
(global-set-key (kbd "M-o")  'mode-line-other-buffer)

;; breathing room from margin
(setq-default left-margin-width 15 right-margin-width 8) ; Define new widths.
(set-window-buffer nil (current-buffer)) ; Use them now.

;; wrap lines
(global-visual-line-mode -1)


;; turn off toolbar and scroll bar
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; turn off bell
(setq ring-bell-function 'ignore)

;; shorter y/n prompts
(defalias 'yes-or-no-p 'y-or-n-p)

;; never keep whitespace at end of line
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq require-final-newline t)


;; whitespace-mode config
(use-package whitespace
  :config
  (setq whitespace-line-column 80)
  (setq whitespace-style '(face tabs empty trailing lines-tail)))


;; which key
(use-package which-key
  :diminish which-key-mode
  :config
  (add-hook 'after-init-hook 'which-key-mode))

;; dashboard
(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-items '((recents  . 5)
                        (bookmarks . 5)
                        (projects . 5)
                        (agenda . 5)
                        (registers . 5))))


;; ;; flycheck
(use-package flycheck
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode)
  (setq flycheck-flake8-maximum-line-length 90)
  ;; (add-hook 'flycheck-mode-hook 'jc/use-eslint-from-node-modules)
  ;; (add-hook 'flycheck-mode-')

  (add-to-list 'flycheck-checkers 'python-mypy)
  (add-to-list 'flycheck-checkers 'python-pylint)
  (add-to-list 'flycheck-checkers 'proselint)
  (setq-default flycheck-highlighting-mode 'lines)
  ;; Define fringe indicator / warning levels
  (define-fringe-bitmap 'flycheck-fringe-bitmap-ball
    (vector #b00000000
            #b00000000
            #b00000000
            #b00000000
            #b00000000
            #b00000000
            #b00000000
            #b00011100
            #b00111110
            #b00111110
            #b00111110
            #b00011100
            #b00000000
            #b00000000
            #b00000000
            #b00000000
            #b00000000))
  (flycheck-define-error-level 'error
    :severity 2
    :overlay-category 'flycheck-error-overlay
    :fringe-bitmap 'flycheck-fringe-bitmap-ball
    :fringe-face 'flycheck-fringe-error)
  (flycheck-define-error-level 'warning
    :severity 1
    :overlay-category 'flycheck-warning-overlay
    :fringe-bitmap 'flycheck-fringe-bitmap-ball
    :fringe-face 'flycheck-fringe-warning)
  (flycheck-define-error-level 'info
    :severity 0
    :overlay-category 'flycheck-info-overlay
    :fringe-bitmap 'flycheck-fringe-bitmap-ball
    :fringe-face 'flycheck-fringe-info))



;; clean up obsolete buffers automatically
(use-package midnight)

;; smart M-x
(use-package smex)

;; unique buffer name

(setq uniquify-buffer-name-style 'post-forward)
(setq uniquify-separator         ":")
(setq uniquify-after-kill-buffer-p t)    ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers



;; NAVIGATION
;; --------------------

;; C-a to to move to first non-whitespace of line
(use-package crux
    :ensure t
    :bind (
		("C-a" . crux-move-beginning-of-line)
		("C-k" .  crux-smart-kill-line))
		("C-c u" . crux-view-url)
		("C-c k" . crux-kill-other-buffers)
		("s-o" . crux-recentf-find-file))

;;  avy allows us to effectively navigate to visible things
(use-package avy
  :config
  (setq avy-background t)
  (setq avy-style 'at-full)

  :bind ("C-:" . avy-goto-char))



;; semantically expand region around cursor
(use-package expand-region
  :bind ("C-=" . er/expand-region))


;; neotree
(use-package all-the-icons)

(use-package neotree
  :config
  (global-set-key (kbd "C-c t") 'neotree-toggle)
  (setq neo-smart-open t)
  (setq neo-theme (if (display-graphic-p) 'icons))
  (setq-default neo-show-hidden-files t)
  (setq projectile-switch-project-action 'neotree-projectile-action))

;; fuzzy search
(use-package fzf)


;; ido
;; (ido-mode t)

(use-package eyebrowse)
(eyebrowse-mode t)

(use-package smart-jump)


;; APPEARANCE
;;--------------------
;; (use-package gruvbox-theme
;;   :config
;;   (load-theme 'gruvbox-dark-hard))
(use-package monokai-theme
  :init
  :config
  (load-theme 'monokai))

  (setq ;; foreground and background
      monokai-foreground     "#ABB2BF"
      monokai-background     "#0A0007")
      ;; highlights and comments
      ;; monokai-comments       "#F8F8F0"
      ;; monokai-emphasis       "#282C34"
      ;; monokai-highlight      "#FFB269"
      ;; monokai-highlight-alt  "#66D9EF"
      ;; monokai-highlight-line "#1B1D1E"
      ;; monokai-line-number    "#F8F8F0"
      ;; ;; colours
      ;; monokai-blue           "#61AFEF"
      ;; monokai-cyan           "#56B6C2"
      ;; monokai-green          "#98C379"
      ;; monokai-gray           "#3E4451"
      ;; monokai-violet         "#C678DD"
      ;; monokai-red            "#E06C75"
      ;; monokai-orange         "#D19A66"
      ;; monokai-yellow         "#E5C07B")

;; (use-package solarized-theme
;;    :config
;;    (load-theme 'solarized))

;; (use-package dracula-theme
;;    :config
;;    (load-theme 'dracula))

(when (eq system-type 'darwin)
  (set-face-attribute 'default nil :family "Source Code Pro for Powerline")
    (set-face-attribute 'default nil :family "Space Mono for Powerline")
    ;; (set-face-attribute 'default nil :family "Meslo LG M DZ for Powerline")
    ;;     (set-face-attribute 'default nil :family "Fira Mono for Powerline")
    ;;     (set-face-attribute 'default nil :family "Inconsolata-dz for Powerline")
   ;; default font size (point * 10)
   ;;
   ;; WARNING!  Depending on the default font,
   ;; if the size is not supported very well, the frame will be clipped
   ;; so that the beginning of the buffer may not be visible correctly.
   (set-face-attribute 'default nil :height 125))


;; (global-display-line-numbers-mode t)
;; (global-hl-line-mode 1)

;; Improve look and feel of titlebar on Macos
;; Set ns-appearance to dark for white title text and nil for black title text.
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))


;; BASIC PROGRAMMING SETTINGS
;;----------------------------------------

;; parenthesis
(use-package smartparens
  :diminish smartparens-mode
  :config
  (add-hook 'prog-mode-hook 'smartparens-mode))

;; highlight parens
(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
  :delight)

;; highlight colors
(use-package rainbow-mode
  :config
  (setq rainbow-x-colors nil)
  (add-hook 'prog-mode-hook 'rainbow-mode)
  :delight)


;; keep things indented
(use-package aggressive-indent)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

;; expand parenthesis
(add-hook 'prog-mode-hook 'electric-pair-mode)

;; fix reading environemnt variables from shell
(use-package exec-path-from-shell
  :init (setq exec-path-from-shell-check-startup-files nil)
  :config
  (exec-path-from-shell-initialize))


;; pretty symbols for things like lambda
(setq prettify-symbols-unprettify-at-point 'right-edge)
(global-prettify-symbols-mode 0)


;; (use-package powerline
;;     :disabled
;;     :config
;;     (setq powerline-default-separator 'utf-8))


(use-package smart-mode-line
  :init
	(setq sml/theme 'dark)
    ;; (setq sml/shorten-directory t)
    ;; (setq sml/shorten-modes t)
    (setq sml/use-projectile-p 't)
	(setq sml/name-width 20)
	(setq sml/mode-width 'full)
	;; (setq sml/replacer-regexp-list '((".*" "")))
	(sml/setup))


;; PROJECT MANAGEMENT
;;--------------------


(use-package projectile
  :config
  (projectile-mode)
  (setq projectile-completion-system 'helm)
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  :delight '(:eval (concat " " (projectile-project-name)))) ;; remove mode name but keep project name

(use-package magit
  :bind ("C-x g" . magit-status))

(add-to-list 'load-path "~/.emacs.d/packages/magit-gitflow")
(use-package magit-gitflow
  :config (add-hook 'magit-mode-hook 'turn-on-magit-gitflow))


  (use-package git-gutter
	:config
	(global-git-gutter-mode 't)
	:diminish git-gutter-mode
	:bind (("M-n" . git-gutter:next-hunk)
           ("M-p" . git-gutter:previous-hunk)
           (""))
	)



;; AUTOCOMPLETE
;;--------------------

(use-package company
  :diminish
  :config
  (add-hook 'after-init-hook 'global-company-mode)

  (setq company-idle-delay t)

  (use-package company-anaconda
    :config
    (add-to-list 'company-backends 'company-anaconda)))

;; (setq company-dabbrev-downcase nil)


;; ----------------------------------------



;; markdown
(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))





;; PYTHON
;; --------------------

(add-hook 'python-mode-hook
	    (lambda ()
		    (setq-default indent-tabs-mode t)
		    (setq-default tab-width 4)
		    (setq-default py-indent-tabs-mode t)))

(when (fboundp 'exec-path-from-shell-copy-env)
  (exec-path-from-shell-copy-env "PYTHONPATH"))

(use-package eldoc
  :delight)

(use-package anaconda-mode
  :config
  (add-hook 'python-mode-hook 'anaconda-mode)
  (add-hook 'python-mode-hook 'anaconda-eldoc-mode))

(setq flycheck-python-flake8-executable "/usr/local/bin/flake8")


(use-package blacken
  :hook (python-mode . blacken-mode))


;; (use-package py-autopep8
;;   :config
;;   ;; (add-hook 'python-mode-hook 'py-autopep8-enable-on-save)
;;   (setq py-autopep8-options '("--max-line-length=100")))

(use-package pipenv
  :hook (python-mode . pipenv-mode)
  :config (setq pipenv-with-projectile, t)
  (setq pipenv-projectile-after-switch-function, #'pipenv-projectile-after-switch-default))


;; ORG MODE
;; --------------------



(setq org-directory "~/org")
(setq org-default-notes-file "~/org/notes.org")

(setq org-agenda-files
      '("~/org/notes.org" "~/org/refile.org"))

(setq org-refile-targets
      '((nil :maxlevel . 1)
        (org-agenda-files :maxlevel . 2)))


;; I use C-c c to start capture mode
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key  (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c b") 'org-switch)
;; remap refile to not overlap with eybrowse
(global-set-key (kbd "C-c r") 'org-refile)

(org-babel-do-load-languages
 'org-babel-load-languages '((shell . t)
							(python . t)))



;; Remove empty LOGBOOK drawers on clock out
(defun bh/remove-empty-drawer-on-clock-out ()
  (interactive)
  (save-excursion
    (beginning-of-line 0)
    (org-remove-empty-drawer-at "LOGBOOK" (point))))

(add-hook 'org-clock-out-hook 'bh/remove-empty-drawer-on-clock-out 'append)



;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/org/notes.org")
               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
              ;; ("b" "bookmark" item (file+headline "~/org/notes.org" "Bookmarks")
              ;;   "* BOOKMARK %:link%:description\n%?%^G\n%U\n")
              ("b" "Bookmark" entry (file+headline "~/org/notes.org" "Bookmarks")
	           "* %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n" :empty-lines 1)
              ("r" "respond" entry (file "~/org/notes.org")
               "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
              ("n" "note" entry (file "~/org/notes.org")
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
              ("j" "Journal" entry (file+datetree "~/org/diary.org")
               "* %?\n%U\n" :clock-in t :clock-resume t)
              ("w" "org-protocol" entry (file "~/org/notes.org")
               "* TODO Review %c\n%U\n" :immediate-finish t)
              ("m" "Meeting" entry (file "~/org/notes.org")
               "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
              ("p" "Phone call" entry (file "~/org/notes.org")
               "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
              ("h" "Habit" entry (file "~/org/notes.org")
               "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))



;; make a shell script executable automatically on save
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)





;; ;; duck-duck-go
;; (setq load-path (cons "~/.emacs.d/plugins/duckduckgo" load-path))
;; (use-package ddg)
;; (use-package ddg-search)
;; (use-package ddg-mode)

;; (require 'ddg)
;; (require 'ddg-search)
;; (require 'ddg-mode)
;; (global-set-key (kbd "M-q") 'duckduckgo-web)


;; multiterm
(add-to-list 'load-path "~/.emacs.d/packages")
(use-package multi-term
  :config (setq multi-term-program "/bin/zsh")
  :bind ("C-x C-t" . multi-term))

;; highlight indents
;; (add-to-list 'load-path "~/.emacs.d/packages/highlight-indent")
;; (use-package highlight-indentation
;;   :hook (python-mode . highlight-indentation-mode))



;;----------------------------------------------------------
;; ---- BEGIN Email client ----
;;----------------------------------------------------------
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu/mu4e")
(require 'mu4e)

;; default
(setq mu4e-maildir "~/Maildir")
(setq mu4e-drafts-folder "/[Gmail].Drafts")
(setq mu4e-sent-folder   "/[Gmail].Sent Mail")
(setq mu4e-trash-folder  "/[Gmail].Trash")
(setq mu4e-refile-folder "/[Gmail].Archive")

;; don't save message to Sent Messages, Gmail/IMAP takes care of this
(setq mu4e-sent-messages-behavior 'delete)

;; setup some handy shortcuts
;; you can quickly switch to your Inbox -- press ``ji''
;; then, when you want archive some messages, move them to
;; the 'All Mail' folder by pressing ``ma''.
(setq mu4e-maildir-shortcuts
      '( ("/INBOX"               . ?i)
         ("/[Gmail].Sent Mail"   . ?s)
         ("/[Gmail].Trash"       . ?t)
		 ("/[Gmail].Starred"     . ?p)
         ("/[Gmail].All Mail"    . ?a)))

;; allow for updating mail using 'U' in the main view:
(setq mu4e-get-mail-command "offlineimap")

;; show images
(setq mu4e-view-show-images t)

;; use imagemagick, if available
(when (fboundp 'imagemagick-register-types)
  (imagemagick-register-types))

;; Sometimes html email is just not readable in a text based client, this lets me open the
;; email in my browser. `aV` in view to activate
(add-to-list 'mu4e-view-actions '("View in browser" . mu4e-action-view-in-browser) t)

;; make messages easier to read
(setq shr-color-visible-luminance-min 80)

;; use the default mu4e-shr2text
(add-hook 'mu4e-view-mode-hook
  (lambda()
    ;; try to emulate some of the eww key-bindings
    (local-set-key (kbd "<tab>") 'shr-next-link)
    (local-set-key (kbd "<backtab>") 'shr-previous-link)))

;; spell check
(add-hook 'mu4e-compose-mode-hook
        (defun my-do-compose-stuff ()
           "My settings for message composition."
           (set-fill-column 72)
           (flyspell-mode)))


;; This enabled the thread like viewing of email similar to gmail's UI.
(setq mu4e-headers-include-related t)
(setq mu4e-attachment-dir  "~/attachments")

(setq mu4e-use-fancy-chars t)

;; fetch mail every 10 mins
(setq mu4e-update-interval 600)

;; something about ourselves
(setq
 user-mail-address "cpsweene@gmail.com"
 user-full-name  "Cam Sweeney")
 ;; message-signature
 ;; (concat
 ;;  "任文山 (Ren Wenshan)\n"
 ;;  "Email: renws1990@gmail.com\n"
 ;;  "Blog: wenshanren.org\n"
 ;;  "Douban: www.douban.com/people/renws"
 ;;  "\n"))


;;for emacs-24 you can use:
(setq message-send-mail-function 'smtpmail-send-it
    smtpmail-stream-type 'starttls
    smtpmail-default-smtp-server "smtp.gmail.com"
    smtpmail-smtp-server "smtp.gmail.com"
    smtpmail-smtp-service 587)



;;  ;; Include a bookmark to open all of my inboxes
;; (add-to-list 'mu4e-bookmarks
;;        (make-mu4e-bookmark
;;         :name "All Inboxes"
;;         :query "maildir:/Exchange/INBOX OR maildir:/Gmail/INBOX"
;;         :key ?i))

;; This allows me to use 'helm' to select mailboxes
(setq mu4e-completing-read-function 'completing-read)
;; Why would I want to leave my message open after I've sent it?
(setq message-kill-buffer-on-exit t)
;; Don't ask for a 'context' upon opening mu4e
(setq mu4e-context-policy 'pick-first)
;; Don't ask to quit... why is this the default?
(setq mu4e-confirm-quit nil)


;;store org-mode links to messages
(require 'org-mu4e)
;;store link to message if in header view, not to header query
(setq org-mu4e-link-query-in-headers-mode nil)


;;----------------------------------------------------------
;; ---- END Email client ----
;;----------------------------------------------------------


;; KEYBINDINGS




;; multiple-cursors
(use-package multiple-cursors
  :config
  (global-unset-key (kbd "M-<down-mouse-1>"))
  (global-set-key (kbd "M-<mouse-1>") 'mc/add-cursor-on-click))

;; nov.el for reading ebooks
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))


(use-package helm
  :bind (("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ([f10] . helm-buffers-list)
         ([S-f10] . helm-recentf))
         ("M-x" . #'helm-M-x)
         ("C-x r b" . #'helm-filtered-bookmarks)
         ("C-x b" . #'helm-mini)
        ("s-i" . #'helm-imenu)
        ("M-s o" . #'helm-occur)
        ("C-x C-f" . #'helm-find-files))

(helm-autoresize-mode 1)
(helm-mode 1)


;; MUSIC
;; ----------------

;; using mpdel instead of emms, because it works great with mopidy
(use-package mpdel
  :diminish)
(mpdel-mode)
(setq libmpdel-music-directory "~/Documents/music/")



;; Init.el ends here
