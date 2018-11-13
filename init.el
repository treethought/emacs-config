;; init.el --- Emacs configuration

;; SETUP
;; --------------------------------------



(require 'package)

(package-initialize)


;; package sources
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(setq package-enable-at-startup nil)


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
(defun find-config ()
  "Edit config.org"
  (interactive)
  (find-file "~/emacs.d/init.el"))

;; (global-set-key (kbd "C-c I") 'find-config)





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
(desktop-save-mode 1)

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

;; breathing room from margin
(setq-default left-margin-width 5 right-margin-width 8) ; Define new widths.
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
(use-package uniquify
  :config
  (setq uniquify-buffer-name-style 'post-forward)
  (setq uniquify-separator         ":"))


;; NAVIGATION
;; --------------------

;; C-a to to move to first non-whitespace of line
;; (use-package crux
;;     :ensure t
;;     :bind (("C-a" . crux-move-beginning-of-line)))

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
(ido-mode t)




;; APPEARANCE
;;--------------------
(use-package gruvbox-theme
  :config
  (load-theme 'gruvbox-dark-hard))
;; (use-package monokai-theme
;;   :config
;;   (load-theme 'monkai))

;; (use-package solarized-theme
;;    :config
;;    (load-theme 'solarized))

;; (use-package dracula-theme
;;    :config
;;    (load-theme 'dracula))

(when (eq system-type 'darwin)
  (set-face-attribute 'default nil :family "Source Code Pro for Powerline")
   ;; default font size (point * 10)
   ;;
   ;; WARNING!  Depending on the default font,
   ;; if the size is not supported very well, the frame will be clipped
   ;; so that the beginning of the buffer may not be visible correctly.
   (set-face-attribute 'default nil :height 135))


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
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

;; highlight colors
(use-package rainbow-mode
  :config
  (setq rainbow-x-colors nil)
  (add-hook 'prog-mode-hook 'rainbow-mode))

; (require 'volatile-highlights)
; (volatile-highlights-mode t)
; (diminish 'volatile-highlights-mode)

;; keep things indented
(use-package aggressive-indent)

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

  ;; (add-hook
  ;;  'python-mode-hook
  ;;  (lambda ()
  ;;    (mapc (lambda (pair) (push pair prettify-symbols-alist))
  ;;          '(("def" . "𝒇")
  ;;            ("class" . "𝑪")
  ;;            ("and" . "∧")
  ;;            ("or" . "∨")
  ;;            ("not" . "￢")
  ;;            ("in" . "∈")
  ;;            ("not in" . "∉")
  ;;            ("return" . "⟼")
  ;;            ("yield" . "⟻")
  ;;            ("for" . "∀")
  ;;            ("!=" . "≠")
  ;;            ("==" . "＝")
  ;;            (">=" . "≥")
  ;;            ("<=" . "≤")
  ;;            ("[]" . "⃞")
  ;;            ("=" . "≝")))))


;; powerline
(use-package powerline
    :disabled
    :config
    (setq powerline-default-separator 'utf-8))



;; PROJECT MANAGEMENT
;;--------------------


(use-package projectile
  :config
  (projectile-mode)
  (setq projectile-completion-system 'ivy)
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(use-package magit
  :bind ("C-x g" . magit-status))


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

(when (fboundp 'exec-path-from-shell-copy-env)
  (exec-path-from-shell-copy-env "PYTHONPATH"))

(use-package anaconda-mode
  :config
  (add-hook 'python-mode-hook 'anaconda-mode)
  (add-hook 'python-mode-hook 'anaconda-eldoc-mode))

(setq flycheck-python-flake8-executable "/usr/local/bin/flake8")

(use-package blacken)

(use-package py-autopep8
:config (add-hook 'python-mode-hook 'py-autopep8-enable-on-save))

(use-package pipenv
  :hook (python-mode . pipenv-mode)
  :init
  (setq
   pipenv-projectile-after-switch-function #'pipenv-projectile-after-switch-default))


;; ORG MODE
(setq uniquify-after-kill-buffer-p t)    ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers








;; make a shell script executable automatically on save
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)





;; ;; duck-duck-go
;; (setq load-path (cons "~/.emacs.d/plugins/ddg" load-path))
;; (require 'ddg)
;; (require 'ddg-search)
;; (require 'ddg-mode)
;; (global-set-key (kbd "M-q") 'duckduckgo-web)


;; multiterm
(add-to-list 'load-path "~/.emacs.d/packages")
(use-package multi-term
  :config (setq multi-term-program "/bin/zsh")
  :bind ("C-x C-t" . multi-term))



;; KEYBINDINGS

(global-set-key (kbd "s-i") 'helm-imenu)



;; init.el ends here
