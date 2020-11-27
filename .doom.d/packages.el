;; -*- no-byte-compile: t; -*-
;;; .doom.d/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:host github :repo "username/repo"))
;; (package! builtin-package :disable t)

(package! kanji-mode)
(package! kanji-glasses-mode :recipe (:host github :repo "correl/kanji-glasses-mode"))
(package! kerl :recipe (:host github :repo "correl/kerl.el"))
(package! migemo)
(package! owo-mode :recipe (:host github :repo "correl/owo-mode"))
(package! ox-confluence-en :recipe (:host github :repo "correl/ox-confluence-en"))
(package! ox-tufte)
(package! jira-api :recipe (:host github :repo "correl/jira-api"))
(package! ob-http)
(package! paredit)
(package! uuidgen)
(package! unfill)
(package! emms)
(package! org-sticky-header)
(package! kubernetes)
(package! kubernetes-tramp)
(package! mixed-pitch)
(package! ox-dnd :recipe (:host github :repo "xeals/emacs-org-dnd"))
(package! gnuplot)
(package! org-roam-server)
(package! nov)
(package! org-ref)
(package! python-black)
(package! poetry)
(package! yapfify)

(package! org-roam-bibtex
  :recipe (:host github :repo "org-roam/org-roam-bibtex"))

;; When using org-roam via the `+roam` flag
(unpin! org-roam company-org-roam)

;; When using bibtex-completion via the `biblio` module
(unpin! bibtex-completion helm-bibtex ivy-bibtex)
