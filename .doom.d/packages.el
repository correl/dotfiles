;; -*- no-byte-compile: t; -*-
;;; .doom.d/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:host github :repo "username/repo"))
;; (package! builtin-package :disable t)

(package! kanji-mode)
(package! kanji-glasses-mode :recipe (:host github :repo "correl/kanji-glasses-mode"))
(package! kerl :recipe (:host github :repo "correl/kerl.el"))
(package! owo-mode :recipe (:host github :repo "correl/owo-mode"))
(package! ox-confluence-en :recipe (:host github :repo "correl/ox-confluence-en"))
(package! jira-api :recipe (:host github :repo "correl/jira-api"))
(package! ob-http)
(package! paredit)
(package! uuidgen)
(package! unfill)
(package! emms)
(package! org-sticky-header)
(package! kubernetes)
