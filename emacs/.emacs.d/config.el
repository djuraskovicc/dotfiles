(setenv "LC_COLLATE" "C")
(setq x-hyper-keysym 'Hyper_L)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(straight-use-package 'org)

(load-theme 'tango-dark t)

(defvar zeko/cooking-timer-process nil "Timer process for the cooking timer.")
(defvar zeko/cooking-timer-remaining-time -1 "Remaining time in seconds for cooking timer.")
(defvar zeko/cooking-timer-sound "~/.emacs.d/sounds/sabaton.mp3" "Sound that's being played when timer is finished.")

(defun zeko/cooking-timer-countdown ()
  "Function that updates echo area with remaining time."
  (setq zeko/cooking-timer-remaining-time (1- zeko/cooking-timer-remaining-time))
  (let ((minutes (floor zeko/cooking-timer-remaining-time 60))
        (seconds (% zeko/cooking-timer-remaining-time 60)))
    (message "Timer: %02d:%02d left" minutes seconds)
    (when (eq zeko/cooking-timer-remaining-time 0)
        (message "Timer: Done!")
        (emms-play-file zeko/cooking-timer-sound)
        (cancel-timer zeko/cooking-timer-process)
        (setq zeko/cooking-timer-process nil)
        (setq zeko/cooking-timer-remaining-time -1))))

(defun zeko/cooking-timer-cancel ()
  "Cancel the running cooking timer."
  (interactive)
  (if zeko/cooking-timer-process
      (progn
        (cancel-timer zeko/cooking-timer-process)
        (setq zeko/cooking-timer-process nil)
        (setq zeko/cooking-timer-remaining-time -1)
        (message "Timer canceled..."))
    (message "No timer running...")))

(defun zeko/cooking-timer-start ()
  (interactive)
  "Play a sound after period of time in minutes"
  (let ((number (read-number "Time in minutes: ")))
    (if zeko/cooking-timer-process
        (message "Timer is already running, cancel it first!")
      (progn
        (setq zeko/cooking-timer-remaining-time (* number 60))
        (setq zeko/cooking-timer-process
              (run-at-time 0 1 #'zeko/cooking-timer-countdown))))))

(defun zeko/yank-n-times (n)
  "Yank (paste) the top of the kill buffer N times."
  (interactive "p")
  (dotimes (_ n)
    (yank)
    (newline)))

(setq dired-listing-switches "-lha --group-directories-first --time-style=+%d/%m/%Y")

(use-package emms
  :straight t
  :commands (zeko/emms-playlist-new-named emms-smart-browse emms-start)
  :init
  (defun zeko/capitalize-words (str)
    "Capitalize each word in the input string STR, and make the rest of the string lowercase."
    (mapconcat
     (lambda (word)
       (concat (upcase (substring word 0 1))
               (downcase (substring word 1))))
     (split-string str)
     " "))

  :config
  (require 'emms-setup)
  (require 'emms-playlist-mode)
  (emms-standard)
  (emms-default-players)
  
  (setq emms-cache-file "~/.emacs.d/emms/cache")
  (setq emms-info-asynchronously t)

  (defun zeko/emms-playlist-new-named (name)
    "Create and switch to new EMMS playlist named NAME."
    (interactive "sEnter playlist name: ")
    (let* ((capitalized-name (zeko/capitalize-words name))
           (formatted-name (format "*EMMS: %s*" capitalized-name))
           (buf (emms-playlist-new formatted-name))
           (dir (expand-file-name (concat "~/Music/" capitalized-name))))

      (unless (file-directory-p dir)
        (kill-buffer buf)
        (cl-return-from zeko/emms-playlist-new-named (format "Directory `%s` not found!" dir)))

      (switch-to-buffer buf)
      (emms-playlist-set-playlist-buffer buf)
      (emms-add-directory dir))))

(setq eww-search-prefix "http://127.0.0.1:8888/search?q=")

(set-face-attribute 'default nil
		    :font "JetBrains Mono"
 		    :height 120
 		    :weight 'medium)

(set-fontset-font t 'unicode
                (font-spec :family "Noto Color Emoji"))

;; These make commented text and keywords italic.
(set-face-attribute 'font-lock-comment-face nil
		    :slant 'italic)

(set-face-attribute 'font-lock-keyword-face nil
		    :slant 'italic)

;; Uncomment the following line if spacing needs adjusting
(setq-default line-spacing 0.12)

(use-package rust-mode 
  :straight t
  :mode ("\\.rs\\'" . rust-mode)
  :hook (rust-mode . (lambda () (face-remap-add-relative 'default :height 140))))

(add-hook 'conf-toml-mode-hook (lambda () 
				 (font-lock-mode -1)
				 (display-line-numbers-mode)))

(defvar zeko/mode-list
  '((rust-mode . "cargo run")
    (c-mode    . "make"))
  "Mapping major programming modes to compile commands.")

(defun zeko/language-options (option)
  "Provide build/compile/test option and switch to that buffer."
  (when option
    (compile option)
    (select-window (get-buffer-window "*compilation*"))))

(defun zeko/compile-for-major-mode ()
  "Get the compile command for the current major mode and run it."
  (interactive)
  (if-let ((command (alist-get major-mode zeko/mode-list)))
    (progn
	    (compile command)
      ;; Small delay to get the window appear, then select it
      (select-window (get-buffer-window "*compilation*")))
    (message "No compile command defined for %s" major-mode)))

;; Will uncomment later...
;;(menu-bar-mode -1)
;;(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq display-line-numbers-type 'relative)
(global-visual-line-mode t)
(add-hook 'text-mode-hook #'display-line-numbers-mode)
(add-hook 'text-mode-hook (lambda () (font-lock-mode -1)))

(defun zeko/org-babel-tangle-on-save ()
  "Tangle the current buffer if #+auto_tangle: t is present."
  (when (and (eq major-mode 'org-mode)
	         'buffer-modified-p
             (save-excursion
               (goto-char (point-min))
               (search-forward "#+auto_tangle: t" nil t)))
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'after-save-hook #'zeko/org-babel-tangle-on-save)

(use-package toc-org
  :straight t
  :commands toc-org-enable
  :init (add-hook 'org-mode-hook 'toc-org-enable))

(add-hook 'org-mode-hook 'org-indent-mode)
(use-package org-bullets :straight t)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(add-hook 'org-mode-hook #'font-lock-mode)

(electric-indent-mode -1)

(require 'org-tempo)

(setq org-src-fontify-natively nil)

(defun my-org-faces ()
    (set-face-attribute 'org-todo nil :height 0.9)
    (set-face-attribute 'org-document-title nil :height 2.0 :foreground "white")
    (set-face-attribute 'org-level-1 nil :height 1.7)
    (set-face-attribute 'org-level-2 nil :height 1.6)
    (set-face-attribute 'org-level-3 nil :height 1.5)
    (set-face-attribute 'org-level-4 nil :height 1.4)
    (set-face-attribute 'org-level-5 nil :height 1.3)
    (set-face-attribute 'org-level-6 nil :height 1.2)
    (set-face-attribute 'org-level-7 nil :height 1.1)
    (set-face-attribute 'org-level-8 nil :height 1.0))

(add-hook 'org-mode-hook #'my-org-faces)
(add-hook 'org-mode-hook (lambda () (face-remap-add-relative 'default :height 130)))

(use-package elfeed :straight t)

(use-package elfeed-org
  :straight t
  :after elfeed
  :config
  (setq rmh-elfeed-org-files '("~/org/elfeed.org"))
  (elfeed-org))
        
(defun zeko/elfeed-show-eww-if-tag (entry tag)
  "Browse elfeed ENTRY in eww if it is tagged with TAG."
  (when (member tag (elfeed-entry-tags entry))
    (let ((browse-url-browser-function #'eww-browse-url))
      (elfeed-show-visit))))

(defun zeko/elfeed-show-eww-if-tag-is-browse (entry)
  "Browse elfeed ENTRY in eww if it has the tag `browse'."
  (zeko/elfeed-show-eww-if-tag entry 'browse))

(defun zeko/elfeed-tag-buzzwords (entry)
  "Remove buzzwords and topics from elfeed."
  (let ((title (elfeed-entry-title entry)))
    (when (string-match-p
 	   (rx (or "ai" "llm" "openai" "ai-generated" "chatgpt"))
	   (downcase title))
      (elfeed-tag entry 'buzzword))))

(setq-default elfeed-search-filter "@3-months-ago -buzzword")
(advice-add #'elfeed-show-entry :after #'zeko/elfeed-show-eww-if-tag-is-browse)
(add-hook 'elfeed-new-entry-hook #'zeko/elfeed-tag-buzzwords)

(defun zeko/ibuffer-toggle ()
  "Toggle ibuffer buffer."
  (interactive)
  (if-let ((buf (get-buffer "*Ibuffer*")))
      (switch-to-buffer buf)
    (ibuffer)))

(keymap-set global-map "<f9>" #'zeko/ibuffer-toggle)

(with-eval-after-load 'ibuffer
  (define-prefix-command 'zeko/ibuffer)
  (keymap-set global-map "C-c i" 'zeko/ibuffer)

  (keymap-set 'zeko/ibuffer "g" #'ibuffer-toggle-filter-group)
  (keymap-set 'zeko/ibuffer "r" #'ibuffer-filter-disable)
  (keymap-set 'zeko/ibuffer "a" #'ibuffer-switch-to-saved-filter-groups))

(defun zeko/open-config ()
  "Open my main Emacs config."
  (interactive)
  (find-file (expand-file-name "~/.emacs.d/config.org")))

(defun zeko/reload-init-file ()
  "Reload Emacs init file."
  (interactive)
  (load-file user-init-file))

(define-prefix-command 'zeko/config)
(keymap-set global-map "C-c e" 'zeko/config)

(keymap-set 'zeko/config "c" #'zeko/open-config)
(keymap-set 'zeko/config "r" #'zeko/reload-init-file)

(keymap-set global-map "H-c" #'zeko/compile-for-major-mode)

;; Rust-specific "Run Options" using lambdas
(with-eval-after-load 'rust-mode
  (keymap-set rust-mode-map "H-x r" (lambda () (interactive) (zeko/language-options "cargo build --release")))
  (keymap-set rust-mode-map "H-x t" (lambda () (interactive) (zeko/language-options "cargo test"))))

(define-prefix-command 'zeko/elfeed)
(keymap-set global-map "C-c f" 'zeko/elfeed)

(keymap-set 'zeko/elfeed "o" #'elfeed)
(keymap-set 'zeko/elfeed "u" #'elfeed-update)

(define-prefix-command 'zeko/emms)
(keymap-set global-map "C-c m" 'zeko/emms)

(keymap-set 'zeko/emms "d" #'zeko/emms-playlist-new-named)
(keymap-set 'zeko/emms "n" #'emms-next)
(keymap-set 'zeko/emms "m" #'emms-shuffle)
(keymap-set 'zeko/emms "l" #'emms-previous)
(keymap-set 'zeko/emms "q" #'emms-stop)
(keymap-set 'zeko/emms "p" #'emms-pause)
(keymap-set 'zeko/emms "f" #'emms-play-file)

(keymap-set global-map "H-y" #'zeko/yank-n-times)

(use-package pacmacs 
  :straight t
  :hook (pacmacs-mode . (lambda () 
			  (setq line-spacing 0))))

(defun zeko/prog-mode-setup ()
  "My custom settings for all programming modes."
  (display-line-numbers-mode 1)
  (font-lock-mode -1))

(add-hook 'prog-mode-hook #'zeko/prog-mode-setup)

(use-package pdf-tools
  :straight t
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :hook (pdf-view-mode . pdf-isearch-minor-mode))

(use-package which-key
  :straight t
  :init (which-key-mode 1)
  :config
  (setq which-key-side-window-location 'bottom
	which-key-sort-order #'which-key-key-order-alpha
	which-key-sort-uppercase-first t
	which-key-add-column-padding 1
	which-key-max-display-columns nil
	which-key-min-display-lines 6
	which-key-side-window-slot -10
	which-key-side-window-max-height 0.25
	which-key-idle-delay 0.8
	which-key-max-description-length 25
	which-key-allow-impercise-window-fit t
	which-key-separator " → "))

(use-package wttrin :straight t)
(keymap-set global-map "C-c w w" (lambda () (interactive) (wttrin "Podgorica")))
