;;; init-vertico.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; TODO: ivy-resume  ivy-occur

;; VERTical Interactive COmpletion
(use-package vertico
  :init
  (vertico-mode)
  (vertico-mouse-mode +1)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  ;; (setq vertico-cycle t)

  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)))

;; Completion style for matching regexps in any order
(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;; Enrich existing commands with completion annotations
(use-package marginalia
  :after vertico
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  (marginalia-align 'center)
  :init
  (marginalia-mode))

;; all-the-icons-completion
(use-package all-the-icons-completion
  :after (marginalia all-the-icons)
  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :init
  (all-the-icons-completion-mode))

;; Consulting completing-read
(use-package consult
  :bind (("C-x b" . consult-buffer)
         ("C-x C-b" . consult-buffer)
         ("C-h a" . consult-apropos)
         ("C-s" . consult-line)
         ("M-y" . consult-yank-pop)

         ("C-x C-r" . consult-recent-file)
         ("C-c r" . consult-ripgrep)
         ("C-c b" . consult-bookmark)
         ("M-m" . consult-mark)
         ))
(global-set-key [remap find-file-read-only-other-window] 'consult-buffer-other-window)

;; Mini-Buffer Actions Rooted in Keymaps
(use-package embark
  :bind
  (("C-c C-c" . embark-act)
   ("C-c C-o" . embark-export)
   ;; ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h b" . embark-bindings)) ;; alternative for `describe-bindings'

  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
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


(provide 'init-vertico)
;;; init-vertico.el ends here
