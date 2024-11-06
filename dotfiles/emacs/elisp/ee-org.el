;;; ee-org.el --- main core settings -*- lexical-binding: t; -*-
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



(bind-keys :prefix-map org-map
           :prefix "C-c o"
           ("l" . org-store-link)
           ("a" . org-agenda)
           ("c" . org-capture)
           ("b" . org-switchb))

;; org-babel-map
(with-eval-after-load 'org
  (define-key org-babel-map (kbd "C-=") 'org-babel-mark-block))

;; <s TAB: The old way, C-c C-, New way.
;; (require 'org-tempo) ;; Startup blame

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


(use-package org-modern
  :after org
  :hook (org-mode . org-modern-mode))

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

(provide 'ee-org)
;;; init-org.el ends here
