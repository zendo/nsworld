;;; ee-minibuffer.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; VERTical Interactive COmpletion
(use-package vertico
  :bind (:map vertico-map
              ("<escape>" . #'minibuffer-keyboard-quit)
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char))
  :init
  (vertico-mode)
  (vertico-mouse-mode 1))

;; Completion style for matching regexps in any order
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

;; Enrich existing commands with completion annotations
(use-package marginalia
  :after vertico
  :init
  (marginalia-mode +1))

;; nerd-icons-completion
(use-package nerd-icons-completion
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

;; Consulting completing-read
(use-package consult
  :bind (("C-c M-x" . consult-mode-command)
         ([remap apropos-command] . consult-apropos) ; C-h a
         ([remap list-buffers] . consult-buffer) ; C-x b
         ([remap find-file-read-only-other-window] . consult-buffer-other-window)
         ([remap yank-pop] . consult-yank-pop) ; M-y
         ("C-x C-r" . consult-recent-file)
         ("C-c b" . consult-bookmark)
         ("C-s" . consult-line)
         ("M-." . consult-imenu)
         ("M-m" . consult-mark)))

;; Mini-Buffer Actions Rooted in Keymaps
(use-package embark
  :bind (("C-c C-c" . embark-act)
         ("C-c C-o" . embark-export)
         ("C-h B" . embark-bindings))
  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :after (embark consult)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

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


(provide 'ee-minibuffer)
;;; ee-minibuffer.el ends here
