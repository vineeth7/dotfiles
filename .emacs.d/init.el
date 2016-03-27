;; Updated : 20 Jan 2016

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Load packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'cl-lib)
(eval-when-compile
  (require 'cl))
(load "package")
(package-initialize)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(setq package-archive-enable-alist '(("melpa" deft magit)))
;(package-refresh-contents)

;; Default packages. Check if they are present. Else download them
(defvar vineeth/packages '(auto-complete
                           browse-kill-ring
                           cuda-mode
                           flycheck
                           flymake
                           fuzzy
                           gnuplot
                           jedi
                           marmalade
                           pylint
                           python-mode
                           smex
                           smart-mode-line
                           smart-mode-line-powerline-theme
                           undo-tree
                           yasnippet
                           zenburn-theme)
  "Default packages")

(defun vineeth/packages-installed-p ()
  (cl-loop for pkg in vineeth/packages
        when (not (package-installed-p pkg)) do (cl-return nil)
        finally (cl-return t)))

(unless (vineeth/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg vineeth/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Splash screen
(setq inhibit-splash-screen t
      initial-scratch-message nil
      initial-major-mode 'org-mode)

;; Bars
(scroll-bar-mode -1)
(tool-bar-mode -1)

;; Buffers and Windows
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(global-auto-revert-mode t)
(winner-mode t)
(defun revert-buffer-no-confirm ()
    "Revert buffer without confirmation."
    (interactive)
    (revert-buffer t t))
(defun my-find-file-check-make-large-file-read-only-hook ()
  "If a file is over a given size, make the buffer read only."
  (when (> (buffer-size) (* 1024 1024))
    (setq buffer-read-only t)
    (buffer-disable-undo)
    (fundamental-mode)))
(add-hook 'find-file-hook 'my-find-file-check-make-large-file-read-only-hook)

;; Marking text
(delete-selection-mode t)
(transient-mark-mode t)
(setq x-select-enable-clipboard t)

;; Display settings
;(set-face-attribute 'default nil :height 120)
(global-hi-lock-mode t)
(set-default 'truncate-lines t)
(global-linum-mode t)
(setq linum-mode-inhibit-modes-list '(eshell-mode
                                      term-mode
                                      shell-mode
                                      erc-mode
                                      jabber-roster-mode
                                      jabber-chat-mode
                                      gnus-group-mode
                                      gnus-summary-mode
                                      gnus-article-mode
                                      doc-view-mode))

(defadvice linum-on (around linum-on-inhibit-for-modes)
  "Stop the load of linum-mode for some major modes."
    (unless (member major-mode linum-mode-inhibit-modes-list)
      ad-do-it))

(ad-activate 'linum-on)

(column-number-mode t)
(show-paren-mode t)
(setq-default indicate-empty-lines t)
(when (not indicate-empty-lines)
  (toggle-indicate-empty-lines))

;; Tabs and Indents
(setq-default standard-indent 3)
(setq-default tab-width 3
      indent-tabs-mode nil)

;; Keybinds
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-j") 'newline)
(global-set-key (kbd "C-.") 'tags-search)
(global-set-key (kbd "C-,") 'pop-tag-mark)
(global-set-key [f5] 'revert-buffer-no-confirm)
(global-set-key [f8] 'view-mode)
(global-set-key [f9] 'delete-trailing-whitespace)
(global-set-key (kbd "C-x \\") 'align-regexp)
(global-set-key (kbd "C-S-d") "\C-a\C-k\C-k\C-y\C-y\C-p")
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-x /") 'ac-complete)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;,--------------------
;;| Auto-Complete Mode
;;`--------------------
(require 'auto-complete-config)
(ac-config-default)
(ac-linum-workaround)
(setq ac-auto-start 2
      ac-use-overriding-local-map nil
      ac-use-menu-map t)

;;,------------------
;;| Browse-Kill-Ring
;;`------------------
(require 'browse-kill-ring)
(global-set-key (kbd "M-Y") 'browse-kill-ring)

;;,--------
;;| C-Mode
;;`--------
(setq-default c-basic-offset 4)

(load-theme 'zenburn t)

;;,----------
;;| CUA-Mode
;;`----------
(cua-mode t)
(cua-selection-mode t)
(setq cua-enable-cua-keys nil)
(setq cua-auto-tabify-rectangles nil)
(setq cua-keep-region-after-copy t)

;;,---------------
;;| Doc-View-Mode
;;`---------------
(setq doc-view-continuous t)

;;,--------------------
;;| Electric-Pair-Mode
;;`--------------------
(electric-pair-mode t)

;;,--------------
;;| Flumake-Mode
;;`--------------
(flymake-mode t)

;;,----------
;;| Ido-Mode
;;`----------
(ido-mode t)
(setq ido-enable-flex-matching t
      ido-everywhere t
      ido-use-filename-at-point 'guess
      ido-create-new-buffer 'always
      ido-use-virtual-buffers t)

;;,-----------
;;| Jedi-Mode
;;`-----------
(require 'jedi)
;; Requires the following to be installed as well
;; pip3 install jedi
;; pip3 install epc
(setq py-python-command "/usr/bin/python3")
(setq jedi:environment-root "jedi")  ; or any other name you like
(setq jedi:environment-virtualenv
      (append python-environment-virtualenv
              '("--python" "../../usr/bin/python3")))

(setq jedi:server-command
      '("python3" "~/.emacs.d/elpa/jedi-core-20151214.705/jediepcserver.py"))
(add-hook 'python-mode-hook
	  (lambda ()
	    (jedi:setup)
	    (jedi:ac-setup)))

;;,-------------
;;| Python-Mode
;;`-------------
(require 'python-mode)
(add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
(setq py-electric-colon-active t)
(add-hook 'python-mode-hook 'yas-minor-mode)
(require 'python-mode)

;;,-------------
;;| Recentf
;;`-------------
(setq recentf-max-menu-items 25)

;;,----------------
;;| Smart-Mode-Line
;;`----------------
(add-hook 'after-init-hook 'sml/setup)
(setq sml/no-confirm-load-theme t)
(setq sml/theme 'powerline)
(sml/setup)

;;,----------
;;| Smex-Mode
;;`----------
(setq smex-save-file (expand-file-name ".smex-items" user-emacs-directory))
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

;;,-----------
;;| Tramp-Mode
;;`-----------
(setq tramp-default-method "ssh")
(setq tramp-remote-shell "/bin/zsh")
(global-set-key (kbd "C-S-s") (lambda() (interactive)(find-file "/ssh:avelayu@remote.eos.ncsu.edu|ssh:temp1007@arc.csc.ncsu.edu:/home/temp1007/")))

;;,---------------
;;| Undo-Tree-Mode
;;`---------------
(global-undo-tree-mode)

;;,---------------
;;| Yasnippet-Mode
;;`---------------

;;,---------------------
;;| Which-Function-Mode
;;`---------------------
(which-function-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Hooks                                                                      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;,---------------
;;| Verilog-Hooks
;;`---------------
(setq verilog-auto-newline nil)

(define-skeleton my-verilog-sk-if
  "Insert a skeleton if statement."
  > "if (" '(verilog-sk-prompt-condition) & ")" \n " begin" \n
  > _ \n
  > (- verilog-indent-level-behavioral) "end " \n )

(add-hook 'verilog-mode-hook '(lambda ()
  (add-hook 'write-file-functions (lambda()
      (untabify (point-min) (point-max))
      nil))))

(add-hook 'verilog-mode-hook
          '(lambda ()
             ;; this is quite the hack because we don't respect
             ;; the usual prefix of verilog-mode but sufficient for us
             (define-key verilog-mode-map "\C-c\C-t?"
                         'my-verilog-sk-if)))

(defun my-verilog-up-ifdef ()
  "Go up `ifdef/`ifndef/`else/`endif macros until an enclosing one is found."
  (interactive)
  (let ((pos (point)) (depth 0) done)
    (while (and (not done)
           (re-search-backward "^\\s-*`\\(ifdef\\|ifndef\\|else\\|endif\\)" nil t))
      (if (looking-at "\\s-*`endif")
          (setq depth (1+ depth))
        (if (= depth 0)
            (setq done t)
          (when (looking-at "\\s-*`if")
            (setq depth (1- depth))))))
    (unless done
      (goto-char pos)
      (error "Not inside an `ifdef construct"))))

(defun cpp-highlight-if-0/1 ()
  "Modify the face of text in between #if 0 ... #endif."
  (interactive)
  (setq cpp-known-face '(background-color . "dim gray"))
  (setq cpp-unknown-face 'default)
  (setq cpp-face-type 'dark)
  (setq cpp-known-writable 't)
  (setq cpp-unknown-writable 't)
  (setq cpp-edit-list
        '((#("1" 0 1
             (fontified nil))
           nil
           (background-color . "dim gray")
           both nil)
          (#("0" 0 1
             (fontified nil))
           (background-color . "dim gray")
           nil
           both nil)))
  (cpp-highlight-buffer t))

(defun jpk/c-mode-hook ()
  (cpp-highlight-if-0/1)
  (add-hook 'after-save-hook 'cpp-highlight-if-0/1 'append 'local)
  )

(add-hook 'c-mode-common-hook 'jpk/c-mode-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; File-End                                                                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("~/Desktop/ToDo.org"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
