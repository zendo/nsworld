;;; init-c-cpp-java.el --- Main Development languages -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; Modern C++ syntax highlighting
(leaf modern-cpp-font-lock
  :commands modern-c++-font-lock-mode
  :hook ((c++-mode-hook . modern-c++-font-lock-mode)))

;; Major mode for working with CMake files
(leaf cmake-mode
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'"))

;; Syntax highlighting for CMake files
(leaf cmake-font-lock
  :after cmake-mode
  :commands cmake-font-lock-activate
  :hook ((cmake-mode-hook . cmake-font-lock-activate)))

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

(leaf lsp-java
  :after lsp
  :require t)


(provide 'init-c-cpp-java)
;;; init-c-cpp-java.el ends here
