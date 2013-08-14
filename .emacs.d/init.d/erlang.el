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
