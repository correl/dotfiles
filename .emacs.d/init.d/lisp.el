;; SLIME
(if (file-exists-p "~/quicklisp/slime-helper.el")
    (load (expand-file-name "~/quicklisp/slime-helper.el")))

(setq inferior-lisp-program "clisp")

(mapcar (lambda (mode-hook)
          (eval-after-load "paredit" `(add-hook ',mode-hook #'enable-paredit-mode))
          (eval-after-load "rainbow-delimiters" `(add-hook ',mode-hook #'rainbow-delimiters-mode))
          (eval-after-load "rainbow-identifiers" `(add-hook ',mode-hook #'rainbow-identifiers-mode))
          (add-hook mode-hook (lambda ()
                           (show-paren-mode)
                           (electric-indent-mode 1)
                           (paredit-mode 1)
                           (rainbow-delimiters-mode 1)
                           (rainbow-identifiers-mode 1)))
          )
        '(lisp-mode-hook
          emacs-lisp-mode-hook
          scheme-mode-hook
          lfe-mode-hook
          clojure-mode-hook))

