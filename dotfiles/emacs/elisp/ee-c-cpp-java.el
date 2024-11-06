;;; ee-c-cpp-java.el --- Main Development languages -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(use-package cc-mode
  :ensure nil
  :bind (:map c-mode-base-map
              ("<f12>" . compile))
  :init (setq-default c-basic-offset 4))

;; (leaf cc-mode
;;       :defvar c-mode-base-map
;;       :hook
;;       ((c-mode-hook . lsp)
;;        (c++-mode-hook . lsp))
;;       :config
;;       (leaf ccls :ensure t)
;;       (leaf clang-format
;;             :ensure t
;;             :init
;;             (defun set-hook-after-save-clang-format ()
;;               (add-hook 'after-save-hook 'clang-format-buffer t t))
;;             :hook ((c-mode-hook . set-hook-after-save-clang-format)
;;                    (c++-mode-hook . set-hook-after-save-clang-format))
;;             :bind ((:c-mode-map ([remap indent-whole-buffer] . clang-format-buffer))
;;                    (:c++-mode-map ([remap indent-whole-buffer] . clang-format-buffer))))
;;       (dvorak-set-key-prog c-mode-base-map))

;; (leaf c-mode

;;   :config
;;   (leaf google-c-style
;;     :ensure t
;;     :commands google-set-c-style)

;;   (leaf clang-format
;;     :ensure t
;;     :commands clang-format clang-format-buffer)

;;   (leaf ccls
;;     :ensure t
;;     :custom ((indent-tabs-mode . t)
;;              (tab-width . 2)
;;              (c-basic-offset . 2))
;;     :hook ((c-mode-hook c++-mode-hook)
;;            .
;;            (lambda ()
;;              (lsp)))))


;; Modern C++ syntax highlighting
;; (leaf modern-cpp-font-lock
;;   :commands modern-c++-font-lock-mode
;;   :hook ((c++-mode-hook . modern-c++-font-lock-mode)))

;; Major mode for working with CMake files
;; (leaf cmake-mode
;;   :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'"))

;; Syntax highlighting for CMake files
;; (leaf cmake-font-lock
;;   :after cmake-mode
;;   :commands cmake-font-lock-activate
;;   :hook ((cmake-mode-hook . cmake-font-lock-activate)))

;; Package made for enabling IDE-like features for CMake projects
;; (use-package cmake-ide
;;   :after projectile
;;   :hook (c++-mode . my/cmake-ide-find-project)
;;   :preface
;;   (defun my/cmake-ide-find-project ()
;;     "Finds the directory of the project for cmake-ide."
;;     (with-eval-after-load 'projectile
;;       (setq cmake-ide-project-dir (projectile-project-root))
;;       (setq cmake-ide-build-dir (concat cmake-ide-project-dir "build")))
;;     (setq cmake-ide-compile-command
;;           (concat "cd " cmake-ide-build-dir " && cmake .. && make"))
;;     (cmake-ide-load-db))

;;   (defun my/switch-to-compilation-window ()
;;     "Switches to the *compilation* buffer after compilation."
;;     (other-window 1))
;;   :bind ([remap comment-region] . cmake-ide-compile)
;;   :init (cmake-ide-setup)
;;   :config (advice-add 'cmake-ide-compile :after #'my/switch-to-compilation-window))


;; (use-package ccls
;;   :after projectile
;;   :demand t
;;   :ensure-system-package ccls
;;   :custom
;;   (ccls-sem-highlight-method 'font-lock)
;;   (ccls-args nil)
;;   (ccls-executable (executable-find "ccls"))
;;   (projectile-project-root-files-top-down-recurring
;;    (append '("compile_commands.json" ".ccls")
;;            projectile-project-root-files-top-down-recurring))
;;   :config (add-to-list 'projectile-globally-ignored-directories ".ccls-cache"))

;;; JAVA
;; (leaf lsp-java :ensure t :hook (java-mode-hook . lsp))

;; (leaf groovy-mode :ensure t)

(provide 'ee-c-cpp-java)
;;; init-c-cpp-java.el ends here
