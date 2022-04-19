;;; Package --- Summary
;;; Commentary:
;;; $DOOMDIR/dashboard.el -*- lexical-binding: t; -*-
;;; Code:

(global-set-key (kbd "<f1>") '+doom-dashboard/open)

(defun +doom-dashboard-setup-modified-keymap ()
  (setq +doom-dashboard-mode-map (make-sparse-keymap))
  (map! :map +doom-dashboard-mode-map
        :desc "Find file" "f" #'find-file
        :desc "Bookmark" "b" #'consult-bookmark
        :desc "Recent buffers" "," #'consult-buffer
        :desc "Recent files" "r" #'consult-recent-file
        :desc "Open project" "p" #'project-find-file
        :desc "Open dotfile" "." (cmd! (doom-project-find-file "~/.nsworld/"))
        :desc "Show keybindings" "h" (cmd! (which-key-show-keymap '+doom-dashboard-mode-map))))
(add-transient-hook! #'+doom-dashboard-mode (+doom-dashboard-setup-modified-keymap))
(add-transient-hook! #'+doom-dashboard-mode :append (+doom-dashboard-setup-modified-keymap))
(add-hook! 'doom-init-ui-hook :append (+doom-dashboard-setup-modified-keymap))

(assoc-delete-all "Open private configuration" +doom-dashboard-menu-sections)
(assoc-delete-all "Open documentation" +doom-dashboard-menu-sections)

;; add new item
;; (add-to-list '+doom-dashboard-menu-sections
;;              '("Add journal entry"
;;                :icon (all-the-icons-octicon "calendar" :face 'doom-dashboard-menu-title)
;;                :when (featurep! :lang org +journal)
;;                :face (:inherit (doom-dashboard-menu-title bold))
;;                :action org-journal-new-entry))



(defun my-weebery-is-always-greater ()
  (let* ((banner '(

"███████╗ ███╗   ███╗  █████╗   ██████╗ ███████╗"
"██╔════╝ ████╗ ████║ ██╔══██╗ ██╔════╝ ██╔════╝"
"█████╗   ██╔████╔██║ ███████║ ██║      ███████╗"
"██╔══╝   ██║╚██╔╝██║ ██╔══██║ ██║      ╚════██║"
"███████╗ ██║ ╚═╝ ██║ ██║  ██║ ╚██████╗ ███████║"
"╚══════╝ ╚═╝     ╚═╝ ╚═╝  ╚═╝  ╚═════╝ ╚══════╝"
"                                               "
                   ))
         (longest-line (apply #'max (mapcar #'length banner))))
    (put-text-property
     (point)
     (dolist (line banner (point))
       (insert (+doom-dashboard--center
                +doom-dashboard--width
                (concat line (make-string (max 0 (- longest-line (length line))) 32)))
               "\n"))
     'face 'doom-dashboard-banner)))

(setq +doom-dashboard-ascii-banner-fn #'my-weebery-is-always-greater)
