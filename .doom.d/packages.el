;; -*- no-byte-compile: t; -*-
;;; .doom.d/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:host github :repo "username/repo"))
;; (package! builtin-package :disable t)

(package! counsel)
(package! desktop-environment)
(package! emms)
(package! exwm)
(package! gnuplot)
(package! jira-api :recipe (:host github :repo "correl/jira-api"))
(package! kanji-glasses-mode :recipe (:host github :repo "correl/kanji-glasses-mode"))
(package! kanji-mode)
(package! kerl :recipe (:host github :repo "correl/kerl.el"))
(package! keypression)
(package! kubernetes)
(package! kubernetes-tramp)
(package! migemo)
(package! mixed-pitch)
(package! nov)
(package! ob-http)
(package! org-ref)
(package! org-roam-bibtex :recipe (:host github :repo "org-roam/org-roam-bibtex"))
(package! org-roam-server)
(package! org-sidebar :recipe (:host github :repo "alphapapa/org-sidebar"))
(package! org-sticky-header)
(package! org-transclusion :recipe (:host github :repo "nobiot/org-transclusion"))
(package! owo-mode :recipe (:host github :repo "correl/owo-mode"))
(package! ox-confluence-en :recipe (:host github :repo "correl/ox-confluence-en"))
(package! ox-dnd :recipe (:host github :repo "xeals/emacs-org-dnd"))
(package! ox-tufte)
(package! paredit)
(package! poetry)
(package! python-black)
(package! unfill)
(package! uuidgen)
(package! weechat)
(package! weechat-alert)
(package! yapfify)

;; When using org-roam via the `+roam` flag
(unpin! org-roam company-org-roam)

;; When using bibtex-completion via the `biblio` module
(unpin! bibtex-completion helm-bibtex ivy-bibtex)
