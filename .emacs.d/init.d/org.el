(setq org-publish-project-alist
      '(("org-notes"
         :base-directory "~/org" :base-extension "org"
         :publishing-directory "~/Public/org"
         :publishing-function org-publish-org-to-html
         :section-numbers t
         :table-of-contents t
         :drawers nil
         :creator-info nil
         :recursive t
         :link-home "/"
         :style "<link rel='stylesheet' href='stylesheet.css' />")
        ("org-static"
         :base-directory "~/org" :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :publishing-directory "~/Public/org"
         :recursive t
         :publishing-function org-publish-attachment)
        ("org" :components ("org-notes" "org-static"))))

(setq org-export-html-style-include-scripts nil
      org-export-html-style-include-default nil)
