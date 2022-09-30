;;; -*- lexical-binding: t; -*-

(leaf add-node-modules-path :ensure t)

(leaf prettier-js
  :ensure t
  :defun add-node-modules-path
  :init
  (defun prettier-js-mode-toggle-setup ()
    "prettier-js-modeの有効無効キーバインドをprettier-js-modeが有効に出来るモードで使えるようにします。"
    (interactive)
    (add-node-modules-path)
    ;; 全体フォーマットをEmacsではなくprettierが行うように
    (local-set-key [remap indent-whole-buffer] 'prettier-js)
    ;; M-iでprettierの一時的無効化が出来るように
    (local-set-key (kbd "M-i") 'prettier-js-mode)
    ;; prettierを有効化
    (prettier-js-mode t)))

(leaf web-mode
  :ensure t
  :defvar lsp-enabled-clients web-mode-comment-formats
  :defun sp-local-pair
  :mode
  "\\.[agj]sp\\'"
  "\\.as[cp]x\\'"
  "\\.djhtml\\'"
  "\\.ejs\\'"
  "\\.erb\\'"
  "\\.html?\\'"
  "\\.jsx?\\'"
  "\\.mjsx?\\'"
  "\\.mustache\\'"
  "\\.php\\'"
  "\\.phtml\\'"
  "\\.tpl\\'"
  "\\.tsx?\\'"
  "\\.vue\\'"
  ;; js-modeが指定されているインタプリタにおいてweb-modeが指定されるようにします。
  :interpreter
  `,(seq-filter 'stringp (seq-map (lambda (regex-mode) (pcase regex-mode (`(,regex . js-mode) regex))) interpreter-mode-alist))
  :init
  (defun web-mode-setup ()
    (setq-local lsp-enabled-clients '(ts-ls eslint))
    (lsp)
    (prettier-js-mode-toggle-setup))
  :hook (web-mode-hook . web-mode-setup)
  :custom
  (web-mode-code-indent-offset . 2)
  (web-mode-css-indent-offset . 2)
  (web-mode-enable-auto-indentation . nil)
  (web-mode-enable-auto-quoting . nil)
  (web-mode-enable-current-column-highlight . t)
  (web-mode-enable-current-element-highlight . t)
  (web-mode-markup-indent-offset . 2)
  :custom-face
  (web-mode-jsx-depth-1-face . '((t (:background "#073844"))))
  (web-mode-jsx-depth-2-face . '((t (:background "#083C49"))))
  (web-mode-jsx-depth-3-face . '((t (:background "#08404F"))))
  (web-mode-jsx-depth-4-face . '((t (:background "#094554"))))
  (web-mode-jsx-depth-5-face . '((t (:background "#0A4D5E"))))
  :bind
  (:web-mode-map
   ([remap comment-indent-new-line] . web-mode-comment-indent-new-line)
   ("C-c C-f" . lsp-eslint-apply-all-fixes))
  :config
  ;; コメントを`/*'式から`//'形式にする。
  (add-to-list 'web-mode-comment-formats '("javascript" . "//"))
  (add-to-list 'web-mode-comment-formats '("jsx" . "//"))
  (sp-local-pair 'web-mode "<" ">" :actions nil))

(leaf yarn-mode :ensure t)

(leaf js :custom (js-indent-level . 2))

(leaf ts-comint :ensure t)

(leaf json-mode :ensure t :hook (json-mode-local-vars-hook . lsp) (json-mode-hook . prettier-js-mode-toggle-setup))
(leaf yaml-mode :ensure t :hook (yaml-mode-local-vars-hook . lsp) (yaml-mode-hook . prettier-js-mode-toggle-setup))

;; configure CSS mode company backends
(leaf css-mode
  :custom (css-indent-offset . 2)
  :hook (css-mode-hook . lsp) ((css-mode-hook scss-mode-hook) . prettier-js-mode-toggle-setup))
(leaf less-css-mode :hook (less-css-mode-hook . prettier-js-mode-toggle-setup))

;; nxml
(leaf nxml-mode
  :mode "\\.fxml\\'"
  :defvar nxml-mode-map
  :custom (nxml-slash-auto-complete-flag . t)
  :bind (:nxml-mode-map
         ("M-h" . nil)
         ("C-M-t" . nil)
         ("C-M-p" . nxml-backward-element))
  :config
  (leaf smartparens :config (sp-local-pair 'nxml-mode "<" ">" :actions nil))
  (dvorak-set-key-prog nxml-mode-map))

(provide 'init-web)
;;; init-web.el ends here
