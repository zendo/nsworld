;;; init-vertico.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; TODO: ivy-resume  ivy-occur

;; VERTical Interactive COmpletion
(leaf vertico
  :ensure t
  :bind ((vertico-map
          ("RET" . vertico-directory-enter)
          ("DEL" . vertico-directory-delete-char)))
  :config
  (vertico-mode)
  (vertico-mouse-mode 1)
  :hook (emacs-startup-hook . vertico-mode))

;; Completion style for matching regexps in any order
(leaf orderless
  :ensure t
  :setq ((completion-styles . '(orderless))
         (completion-ignore-case . t)
         (read-buffer-completion-ignore-case . t)
         (read-file-name-completion-ignore-case . t)
         (orderless-smart-case . t)
         (orderless-matching-styles . '(orderless-prefixes
                                        orderless-initialism
                                        orderless-regexp))))

;; Enrich existing commands with completion annotations
(leaf marginalia
  :ensure t
  :after vertico
  :init
  (marginalia-mode +1))

;; all-the-icons-completion
(leaf all-the-icons-completion
  :ensure t
  :config
  (with-eval-after-load 'all-the-icons
    (eval-after-load 'marginalia
      '(progn
         (unless (fboundp 'all-the-icons-completion-marginalia-setup)
           (autoload #'all-the-icons-completion-marginalia-setup "all-the-icons-completion" nil t))
         (all-the-icons-completion-mode)
         (add-hook 'marginalia-mode-hook #'all-the-icons-completion-marginalia-setup)))))

;; Consulting completing-read
(leaf consult
  :ensure t
  :bind (([remap list-buffers] . consult-buffer)              ; C-x b
         ([remap apropos-command] . consult-apropos)             ; C-h a
         ([remap find-file-read-only-other-window] . consult-buffer-other-window)
         ([remap yank-pop] . consult-yank-pop) ; M-y
         ("C-s" . consult-line)
         ("C-x C-r" . consult-recent-file)
         ("C-c r" . consult-ripgrep)
         ("C-c b" . consult-bookmark)
         ("M-m" . consult-mark)))

;; Mini-Buffer Actions Rooted in Keymaps
(leaf embark
  :ensure t
  :bind (("C-c C-c" . embark-act)
         ("C-c C-o" . embark-export)
         ("C-h b" . embark-bindings))
  :setq ((prefix-help-command function embark-prefix-help-command)))

;; Consult users will also want the embark-consult package.
(leaf embark-consult
  :ensure t
  :after (embark consult)
  :hook
  (embark-collect-mode-hook . consult-preview-at-point-mode))

;;----------------------------------------------------------------------------
;; Functions
;;----------------------------------------------------------------------------
;; 箭头显示当前项
;;;###autoload
(advice-add #'vertico--format-candidate :around
            (lambda (orig cand prefix suffix index _start)
              (setq cand (funcall orig cand prefix suffix index _start))
              (concat
               (if (= vertico--index index)
                   (propertize "» " 'face 'vertico-current)
                 "  ")
               cand)))


(provide 'init-vertico)
;;; init-vertico.el ends here
