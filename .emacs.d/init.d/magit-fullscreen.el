;; Magit
(defun magit-fullscreen ()
  (defadvice magit-status (around magit-fullscreen activate)
    (window-configuration-to-register :magit-fullscreen)
    ad-do-it
    (delete-other-windows))

  (defadvice magit-quit-window (around magit-restore-screen activate)
    ad-do-it
    (jump-to-register :magit-fullscreen)))

(eval-after-load 'magit '(magit-fullscreen))
