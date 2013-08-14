;; Git Gutter
(global-git-gutter-mode t)

(defadvice ediff-make-temp-file (before make-temp-file-suspend-ll
                                        activate compile preactivate)
  "Disable git-gutter when running ediff"
  (global-git-gutter-mode 0))

(add-hook 'ediff-cleanup-hook
          '(lambda ()
             (global-git-gutter-mode t)))
