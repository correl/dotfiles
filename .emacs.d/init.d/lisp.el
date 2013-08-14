;; SLIME
(if (file-exists-p "~/quicklisp/slime-helper.el")
    (load (expand-file-name "~/quicklisp/slime-helper.el")))

(setq inferior-lisp-program "clisp")

;; Paredit
(eval-after-load "paredit" '(add-hook 'lisp-mode #'enable-paredit-mode))
