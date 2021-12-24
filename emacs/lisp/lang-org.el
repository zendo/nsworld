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

;; Org-table font
(custom-set-faces
 '(org-table ((t (:family "等距更纱黑体 SC")))))

(bind-keys :prefix-map org-map
           :prefix "C-c o"
           ("l" . org-store-link)
           ("a" . org-agenda)
           ("c" . org-capture)
           ("b" . org-switchb))

;; org-babel-map
(with-eval-after-load 'org
  (define-key org-babel-map (kbd "C-=") 'org-babel-mark-block))

;; <s TAB: The old way, C-c C-: New way.
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


(provide 'lang-org)
;;; lang-org.el ends here
