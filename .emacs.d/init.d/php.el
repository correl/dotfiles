;; PHP Mode
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))

(defun my-php-mode-hook ()
  "Customize PHP indentation"

  (c-set-offset 'arglist-cont-nonempty 'c-lineup-arglist)
  (c-set-offset 'substatement-open 0))

(add-hook 'php-mode-hook 'my-php-mode-hook)

;; Multi-Web-Mode
(require 'multi-web-mode)
(setq mweb-default-major-mode 'html-mode)
(setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
                  (js-mode "<script[^>]*>" "</script>")
                  (css-mode "<style[^>]*>" "</style>")))
(setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
(multi-web-global-mode 1)
