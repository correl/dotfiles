(add-to-list 'load-path "~/.emacs.d/elisp")

(require 'package)
(add-to-list 'package-archives
             '("elpa" . "http://tromey.com/elpa/"))
;; Add the user-contributed repository
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))

;; Milkypostman’s Experimental Lisp Package Repository
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)

(require 'cask "~/.cask/cask.el")
(cask-initialize)

;; Emacs
(global-set-key (kbd "C-,") 'kill-whole-line)

;; Theme
(load-theme 'twilight t)

;; ido-mode
(ido-mode)
(setq ido-enable-flex-matching t)

;; Autocomplete
(require 'auto-complete-config)
(ac-config-default)

;; Expand Region
(global-set-key (kbd "C-=") 'er/expand-region)

;; Window transparency
(set-frame-parameter (selected-frame) 'alpha '(85 85))
(add-to-list 'default-frame-alist '(alpha 85 85))  


;; Load custom init scripts from ~/.emacs.d/init.d
;;
(let ((init-dir "~/.emacs.d/init.d")
      (file-pattern "\\.elc?$"))
  (when (file-directory-p init-dir)
    (mapcar (lambda (lisp-file)
              (load-file lisp-file))
            (directory-files (expand-file-name init-dir) t file-pattern))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blank-chars (quote (tabs trailing space-before-tab)))
 '(blank-global-modes t)
 '(browse-url-browser-function (quote browse-url-generic))
 '(browse-url-generic-program "google-chrome")
 '(c-basic-offset 4)
 '(c-default-style "bsd")
 '(eol-mnemonic-dos "(DOS)")
 '(eol-mnemonic-mac "(Mac)")
 '(haskell-mode-hook (quote (turn-on-haskell-indentation)) t)
 '(indent-tabs-mode nil)
 '(inferior-lisp-program "sbcl")
 '(inhibit-startup-screen t))
(put 'narrow-to-region 'disabled nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 80 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(font-lock-function-name-face ((t (:foreground "LightSkyBlue" :weight bold))))
 '(font-lock-type-face ((t (:foreground "PaleGreen" :weight bold)))))
