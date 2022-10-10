;;; lang-org.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(setq org-startup-indented t
      org-startup-truncated nil
      org-hide-leading-stars t
      org-ellipsis " \u25bc" ;; " ⤵" " ↴" " ➤" " ▼"
      ;; org-columns-default-format "%50ITEM(Task) %10CLOCKSUM %16TIMESTAMP_IA"
      org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9)))
      ;; org-agenda-files
      ;; org-agenda-files (append (file-expand-wildcards "/*.org"))
      ;; babel
      org-confirm-babel-evaluate nil
      org-support-shift-select t
      org-src-fontify-natively t
      org-src-tab-acts-natively t
      ;; capture
      org-capture-templates '(("t" "TODO"
                               entry (file+headline "TODO.org" "TODO")
                               "* TODO %? %T" :prepend t)
                              ("j" "Journal"
                               entry (file+datetree "Journal.org")
                               "* Event: %?\n\n  %i\n\n"
                               :empty-lines 1)))



;; (bind-keys :prefix-map org-map
;;            :prefix "C-c o"
;;            ("l" . org-store-link)
;;            ("a" . org-agenda)
;;            ("c" . org-capture)
;;            ("b" . org-switchb))

;; org-babel-map
(with-eval-after-load 'org
  (define-key org-babel-map (kbd "C-=") 'org-babel-mark-block))

;; <s TAB: The old way, C-c C-, New way.
;; (require 'org-tempo)

;; babel
;; (org-babel-do-load-languages 'org-babel-load-languages
;;                              '((emacs-lisp . t)
;;                                ;(C . t)
;;                                ;(ditaa . t)
;;                                (dot . t)
;;                                ;(js . t)
;;                                ;(css . t)
;;                                ;(latex . t)
;;                                ;(perl . t)
;;                                ;(python . t)
;;                                ;(ruby . t)
;;                                ; (rust . t)
;;                                ; (sh . t)
;;                                (shell . t);
;;                                ;(plantuml . t)
;;                                ;(R . t)
;;                                ;(clojure . t)
;;                                ))


(leaf org-modern
  :ensure t
  :after org
  :hook (org-mode-hook)
  :require t)

;; (use-package org-roam
;;   :custom
;;   (org-roam-directory (file-truename "~/Documents/org/"))
;;   :bind (("C-c n l" . org-roam-buffer-toggle)
;;          ("C-c n f" . org-roam-node-find)
;;          ("C-c n g" . org-roam-graph)
;;          ("C-c n i" . org-roam-node-insert)
;;          ("C-c n c" . org-roam-capture)
;;          ;; Dailies
;;          ("C-c n j" . org-roam-dailies-capture-today))
;;   :config
;;   ;; If you're using a vertical completion framework, you might want a more informative completion interface
;;   (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
;;   (org-roam-db-autosync-mode)
;;   ;; If using org-roam-protocol
;;   (require 'org-roam-protocol))


;; (leaf org
;;   :leaf-defer t
;;   :bind (("C-c c" . org-capture)
;;          ("C-c a" . org-agenda)
;;          (:org-mode-map
;;           ("C-c C-;" . org-edit-special))
;;          (:org-src-mode-map
;;           ("C-c C-;" . org-edit-src-exit)))
;;   :mode ("\\.org$'" . org-mode)
;;   ;; :hook  (org-mode . (lambda ()
;;   ;;                      (set (make-local-variable 'system-time-locale) "C")))
;;   :config
;;   (setq org-directory "~/src/github.com/grugrut/PersonalProject/")
;;   :custom
;;   ;; TODO状態の設定
;;   (org-todo-keywords . '((sequence "TODO(t)" "IN PROGRESS(i)" "|" "DONE(d)")
;;                          (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "MEETING")))
;;   (org-todo-keyword-faces . '(("TODO" :foreground "red" :weight bold)
;;                               ("STARTED" :foreground "cornflower blue" :weight bold)
;;                               ("DONE" :foreground "green" :weight bold)
;;                               ("WAITING" :foreground "orange" :weight bold)
;;                               ("HOLD" :foreground "magenta" :weight bold)
;;                               ("CANCELLED" :foreground "green" :weight bold)
;;                               ("MEETING" :foreground "gren" :weight bold)))
;;   (org-log-done . 'time)
;;   (org-clock-persist . t)
;;   (org-clock-out-when-done . t)
;;   )
;; (leaf org-capture
;;   :leaf-defer t
;;   :after org
;;   :commands (org-capture)
;;   :config
;;   (defvar grugrut/org-inbox-file (concat org-directory "inbox.org"))
;;   (defvar grugrut/org-journal-file (concat org-directory "journal.org"))
;;   (setq org-capture-templates `(
;;                                 ("t" " Tasks" entry (file ,grugrut/org-inbox-file)
;;                                  "* TODO %? %^G\n:PROPERTIES:\n:DEADLINE: %^{Deadline}T\n:EFFORT: %^{effort|1:00|0:05|0:15|0:30|2:00|4:00}\n:END:\n")
;;                                 ("e" " Event" entry (file ,grugrut/org-inbox-file)
;;                                  "* TODO %? %^G\n:PROPERTIES:\n:SCHEDULED: %^{Scheduled}T\n:EFFORT:%^{effort|1:00|0:05|0:15|0:30|2:00|4:00}\n:END:\n")
;;                                 ("j" " Journal" entry (file+olp+datetree ,grugrut/org-journal-file)
;;                                  "* %<%H:%M> %?")
;;                                 ("b" " blog" entry
;;                                  (file+headline "~/src/github.com/grugrut/blog/draft/blog.org" ,(format-time-string "%Y"))
;;                                  "** TODO %?\n:PROPERTIES:\n:EXPORT_HUGO_CUSTOM_FRONT_MATTER: :archives '(\\\"%(format-time-string \"%Y\")\\\" \\\"%(format-time-string \"%Y-%m\")\\\")\n:EXPORT_FILE_NAME: %(format-time-string \"%Y%m%d%H%M\")\n:END:\n\n")
;;                                 )))

;; (leaf org-superstar
;;   :ensure t
;;   :custom
;;   (org-superstar-headline-bullets-list . '("󿕸" "󿖀" "󿕾" "󿕼" "󿕺" "󿖍"))
;;   :hook
;;   (org-mode-hook (lambda () (org-superstar-mode 1)))
;;   )

;; (leaf ox-hugo
;;   :ensure t
;;   :after ox
;;   :mode ("\\.org$'" . org-hugo-auto-export-mode))

;; (leaf ob
;;   :leaf-defer t
;;   :after org
;;   :defun org-babel-do-load-languages
;;   :config
;;   (setq org-plantuml-jar-path "~/bin/plantuml.jar")
;;   (leaf ob-elixir
;;     :ensure t)
;;   (leaf ob-go
;;     :ensure t)
;;   (leaf ob-rust
;;     :ensure t)
;;   (org-babel-do-load-languages
;;    'org-babel-load-languages
;;    '((emacs-lisp . t)
;;      (elixir . t)
;;      (go . t)
;;      (rust . t)
;;      (plantuml . t))))


(provide 'lang-org)
;;; init-org.el ends here
