;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(defun my/org-init-babel ()
  (setq org-src-preserve-indentation nil))

(when (featurep! :lang org)
  (add-hook! 'org-mode-hook #'my/org-init-babel)

  ;; Don't use DOOM's centralized attachment system. It's incompatible with all
  ;; of the org files I already have using the standard setup.
  (setq org-attach-directory "data/")
  (remove-hook! 'org-load-hook
    #'(+org-init-centralized-attachments-h)))
