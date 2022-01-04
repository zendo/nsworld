;;; init-selectrum.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; TODO: ivy-resume  ivy-occur

(use-package selectrum
  :init
  (selectrum-mode +1)
  )

;; (use-package selectrum-prescient
;;   :config
;;   (selectrum-prescient-mode +1)
;;   (prescient-persist-mode +1)
;;   )

(use-package orderless
  :init
  (setq completion-styles '(orderless))
  (setq orderless-skip-highlighting (lambda () selectrum-is-active))
  (setq selectrum-highlight-candidates-function #'orderless-highlight-matches)
  )

(use-package marginalia
  :after selectrum
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

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

(use-package embark
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
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


(provide 'init-selectrum)
