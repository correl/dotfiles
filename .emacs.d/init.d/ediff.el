;; Ediff
(defun command-line-diff (switch)
  (let ((file1 (pop command-line-args-left))
        (file2 (pop command-line-args-left)))
    (ediff file1 file2)))

(add-to-list 'command-switch-alist '("diff" . command-line-diff))

(defun git-mergetool (switch)
  (let ((local (pop command-line-args-left))
        (remote (pop command-line-args-left))
        (base (pop command-line-args-left))
        (merged (pop command-line-args-left)))
    (setq ediff-quit-hook 'kill-emacs
          ediff-quit-merge-hook (lambda ()
                                  (let ((file ediff-merge-store-file))
                                    (set-buffer ediff-buffer-C)
                                    (write-region (point-min) (point-max) file)
                                    (message "Merge buffer saved in: %s" file)
                                    (set-buffer-modified-p nil)
                                    (sit-for 1))))
    (emerge-files-with-ancestor local remote base nil merged)))

(add-to-list 'command-switch-alist '("mergetool" . git-mergetool))
