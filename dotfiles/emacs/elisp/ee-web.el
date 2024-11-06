;;; -*- lexical-binding: t; -*-

(use-package css-mode
  :ensure nil
  :init (setq css-indent-offset 2))

(use-package scss-mode
  :init
  ;; Disable complilation on save
  (setq scss-compile-at-save nil))

(unless (fboundp 'less-css-mode)
  (use-package less-css-mode))

;; nxml
(use-package nxml-mode
  :ensure nil
  :mode (("\\.xaml$" . xml-mode)))

(use-package php-mode
  :mode "\\.php$")

(use-package typescript-mode
  :mode ("\\.ts[x]\\'" . typescript-mode))

;; JavaScript
(use-package js-mode
  :ensure nil
  :defines (js-indent-level flycheck-javascript-eslint-executable)
  :config
  (setq js-indent-level 2)

  (with-eval-after-load 'flycheck
    ;; https://github.com/mantoni/eslint_d.js
    ;; Install: npm -i -g eslint_d
    (when (executable-find "eslint_d")
      (setq flycheck-javascript-eslint-executable "eslint_d"))))


(use-package js2-mode
  :mode (("\\.js\\'" . js2-mode)
         ("\\.jsx\\'" . js2-jsx-mode))
  :interpreter (("node" . js2-mode)
                ("node" . js2-jsx-mode))
  :hook ((js2-mode . js2-imenu-extras-mode)
         (js2-mode . js2-highlight-unused-variables-mode))
  :config
  (with-eval-after-load 'flycheck
    (when (or (executable-find "eslint_d")
              (executable-find "eslint")
              (executable-find "jshint"))
      (setq js2-mode-show-strict-warnings nil))))


;; Adds node_modules/.bin directory to `exec_path'
(use-package add-node-modules-path
  :hook ((web-mode js-mode js2-mode) . add-node-modules-path))

(use-package prettier
  :diminish
  :hook ((js-mode js2-mode css-mode sgml-mode web-mode) . prettier-mode)
  :init (setq prettier-pre-warm 'none))

;; TODO leaf
;; (use-package prettier-js
;;   :init
;;   (defun prettier-js-mode-toggle-setup ()
;;     "prettier-js-modeの有効無効キーバインドをprettier-js-modeが有効に出来るモードで使えるようにします。"
;;     (interactive)
;;     (add-node-modules-path)
;;     ;; 全体フォーマットをEmacsではなくprettierが行うように
;;     (local-set-key [remap indent-whole-buffer] 'prettier-js)
;;     ;; M-iでprettierの一時的無効化が出来るように
;;     (local-set-key (kbd "M-i") 'prettier-js-mode)
;;     ;; prettierを有効化
;;     (prettier-js-mode t)))

(use-package web-mode
  :mode ("\\.[agj]sp\\'"
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
         "\\.vue\\'")
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-indent-style 2))


;; REST
;; (use-package restclient
;;   :mode ("\\.http\\'" . restclient-mode)
;;   :config
;;   (use-package restclient-test
;;     :diminish
;;     :hook (restclient-mode . restclient-test-mode))

;;   (with-eval-after-load 'company
;;     (use-package company-restclient
;;       :defines company-backends
;;       :init (add-to-list 'company-backends 'company-restclient))))

(provide 'ee-web)
;;; ee-web.el ends here
