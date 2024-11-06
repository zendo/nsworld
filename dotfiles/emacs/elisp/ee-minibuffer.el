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
  :init (setq completion-styles '(orderless)
              completion-ignore-case  t
              read-buffer-completion-ignore-case  t
              read-file-name-completion-ignore-case  t
              orderless-smart-case  t
              orderless-matching-styles '(orderless-prefixes
                                          orderless-initialism
                                          orderless-regexp)))

;; Enrich existing commands with completion annotations
(use-package marginalia
  :after vertico
  :init
  (marginalia-mode +1))

;; all-the-icons-completion
(use-package all-the-icons-completion
  :after all-the-icons
  :hook
  (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :init (all-the-icons-completion-mode))

;; Consulting completing-read
(use-package consult
  :bind (([remap list-buffers] . consult-buffer) ; C-x b
         ([remap apropos-command] . consult-apropos) ; C-h a
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
         ("C-h b" . embark-bindings))
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
