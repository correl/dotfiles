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

(ido-mode)

;; Autocomplete
(require 'auto-complete-config)
(ac-config-default)

;; Smex
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

;; Expand Region
(global-set-key (kbd "C-=") 'er/expand-region)

;; Git Gutter
(global-git-gutter-mode t)

(defadvice ediff-make-temp-file (before make-temp-file-suspend-ll
                                        activate compile preactivate)
  "Disable git-gutter when running ediff"
  (global-git-gutter-mode 0))

(add-hook 'ediff-cleanup-hook
          '(lambda ()
             (global-git-gutter-mode t)))

;; Fixes an issue with ECB
;; (setq stack-trace-on-error t)

;; SLIME
(if (file-exists-p "~/quicklisp/slime-helper.el")
    (load (expand-file-name "~/quicklisp/slime-helper.el")))

;; Erlang configuration
(add-to-list
 'load-path
 (car (file-expand-wildcards "/usr/lib/erlang/lib/tools-*/emacs")))
(setq erlang-root-dir "/usr/lib/erlang")
(setq exec-path (cons "/usr/lib/erlang/bin" exec-path))
(require 'erlang-start)
(add-hook 'erlang-mode-hook
             (lambda ()
            ;; when starting an Erlang shell in Emacs, the node name
            ;; by default should be "emacs"
            (setq inferior-erlang-machine-options '("-sname" "emacs"))))

(require 'color-theme)
(color-theme-initialize)
(if (display-graphic-p)
  (color-theme-ld-dark)
  (color-theme-ld-dark))

;; Lisp-Flavored Erlang
(add-to-list
 'load-path
 (car (file-expand-wildcards "/usr/lib/erlang/lib/lfe-*/emacs")))
(require 'lfe-start 'nil 'noerror)

;; Window transparency
(set-frame-parameter (selected-frame) 'alpha '(85 85))
(add-to-list 'default-frame-alist '(alpha 85 85))  

(setq auto-mode-alist
      (cons '("\\.md" . markdown-mode) auto-mode-alist))

(setq ido-enable-flex-matching t)
(global-set-key (kbd "C-,") 'kill-whole-line)

;; PHP Mode
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))

;; Multi-Web-Mode
(require 'multi-web-mode)
(setq mweb-default-major-mode 'html-mode)
(setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
                  (js-mode "<script[^>]*>" "</script>")
                  (css-mode "<style[^>]*>" "</style>")))
(setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
(multi-web-global-mode 1)

;; SLIME
(setq inferior-lisp-program "clisp")

;; emacsredux.com
(defun rename-file-and-buffer ()
  "Rename the current buffer and file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (message "Buffer is not visiting a file!")
      (let ((new-name (read-file-name "New name: " filename)))
        (cond
         ((vc-backend filename) (vc-rename-file filename new-name))
         (t
          (rename-file filename new-name t)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)))))))

(defadvice ido-find-file (after find-file-sudo activate)
  "Find file as root if necessary."
  (unless (and buffer-file-name
               (file-writable-p buffer-file-name))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

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
