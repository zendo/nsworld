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
  ;; :init (leaf flx :ensure t)
  :custom
  `((completion-styles . '(orderless))
    (orderless-matching-styles
     . '(orderless-prefixes
         orderless-flex
         orderless-regexp
         orderless-initialism
         orderless-literal))
    )
  )

;; Enrich existing commands with completion annotations
(leaf marginalia
  :after vertico
  :require t
  :config
  (marginalia-mode))

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
  :bind (("C-x b" . consult-buffer)
         ("C-x C-b" . consult-buffer)
         ("C-h a" . consult-apropos)
         ("C-s" . consult-line)
         ("M-y" . consult-yank-pop)
         ("C-x C-r" . consult-recent-file)
         ("C-c r" . consult-ripgrep)
         ("C-c b" . consult-bookmark)
         ("M-m" . consult-mark)))
(global-set-key [remap find-file-read-only-other-window] 'consult-buffer-other-window)

;; Mini-Buffer Actions Rooted in Keymaps
(leaf embark
  :ensure t
  :bind (("C-c C-c" . embark-act)
         ("C-c C-o" . embark-export)
         ("C-h b" . embark-bindings))
  :setq ((prefix-help-command function embark-prefix-help-command))
  :config
  (with-eval-after-load 'embark
    (add-to-list 'display-buffer-alist
                 '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*" nil
                   (window-parameters
                    (mode-line-format . none))))))

;; Consult users will also want the embark-consult package.
;; (leaf embark-consult
;;   :config
;;   (use-package-ensure-elpa 'embark-consult
;;                            '(t)
;;                            '(:demand t))
;;   (with-eval-after-load 'consult
;;     (eval-after-load 'embark
;;       '(progn
;;          (require 'embark-consult nil nil)
;;          (add-hook 'embark-collect-mode-hook #'consult-preview-at-point-mode)))))

(leaf embark-consult
  :ensure t
  :config
  (with-eval-after-load 'consult
    (eval-after-load 'embark
      '(require 'embark-consult nil nil))))

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
