;;; keybindings.el --- Modify key bindings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(global-set-key (kbd "C-z") 'nil) ;unbind C-zzzzz
(global-set-key [remap kill-buffer] #'kill-this-buffer)
(global-set-key [remap query-replace] 'anzu-query-replace)
(global-set-key [remap query-replace-regexp] 'anzu-query-replace-regexp)

(global-set-key (kbd "<f7>") #'compile)
(global-set-key (kbd "<C-f7>")
                (lambda () (interactive)
                  (save-buffer)
                  (recompile)))

;; move-text M-up/M-down
(use-package move-text
  :init (move-text-default-bindings))

;; easy-kill
(use-package easy-kill
             :config
             (global-set-key [remap mark-sexp] 'easy-mark)
             (global-set-key [remap kill-ring-save] 'easy-kill))

;; crux
(use-package crux
  :bind (("C-a" . crux-move-beginning-of-line)
         ("C-k" . crux-smart-kill-line)
         ;; ("<f4>" . crux-visit-term-buffer)
         ("C-x 4 x" . crux-swap-windows)))
(global-set-key [(control return)] #'crux-smart-open-line)
(global-set-key [(control shift return)] #'crux-smart-open-line-above)

;; major-mode-hydra https://github.com/jerrypnz/major-mode-hydra.el
(use-package major-mode-hydra
  :bind ("<f6>" . major-mode-hydra))

(major-mode-hydra-define emacs-lisp-mode nil
  ("Eval"
   (("b" eval-buffer "buffer")
    ("e" eval-defun "defun")
    ("r" eval-region "region"))
   "REPL"
   (("I" ielm "ielm"))
   "Test"
   (("t" ert "prompt")
    ("T" (ert t) "all")
    ("F" (ert :failed) "failed"))
   "Doc"
   (("d" describe-foo-at-point "thing-at-pt")
    ("f" describe-function "function")
    ("v" describe-variable "variable")
    ("i" info-lookup-symbol "info lookup"))))

;; prefix map
(bind-keys :prefix-map file-map
           :prefix "C-c f"
           ("0" . revert-buffer)
           ("o" . crux-open-with)
           ("r" . crux-rename-file-and-buffer)
           ("x" . crux-delete-file-and-buffer)
           ("s" . crux-sudo-edit)
           ("/" . doom/sudo-find-file))

(bind-keys :prefix-map window-map
           :prefix "C-c w"
           ("w" . burly-bookmark-windows)
           ("f" . burly-bookmark-frames)
           ("o" . burly-open-bookmark)
           ("x" . crux-swap-windows))


(bind-keys*
 ("C-h f" . helpful-callable)
 ("C-h v" . helpful-variable)
 ("C-h k" . helpful-key)
 ("C-h a" . counsel-apropos)

 ("M-+" . text-scale-increase)
 ("M-_" . text-scale-decrease)
 ("<f2>" . crux-rename-file-and-buffer)

 ("M-x" . counsel-M-x)
 ("M-y" . counsel-yank-pop)
 ("C-x C-f" . counsel-find-file)
 ("C-x C-r" . counsel-recentf)
 ("C-c g" . counsel-git)
 ("C-c j" . counsel-git-grep)
 ("C-c r" . counsel-rg)
 ("C-c a" . counsel-ag)
 ("C-x l" . counsel-locate)
 ("C-c b" . counsel-bookmark)
 ("C-x 8 i" . counsel-unicode-char)

 ("C-s" . swiper)
 ("C-c C-r" . ivy-resume)
 ("C-x b" . ivy-switch-buffer)
 ("C-x C-b" . ivy-switch-buffer)
 ("C-c C-o" . ivy-occur)

 ;; ("C-/" . undo-fu-only-undo)
 ;; ("C-?" . undo-fu-only-redo)
 ("C-=" . er/expand-region)
 ("C-." . hippie-expand)
 ("C-;" . iedit-mode)
 ("C-\\" . align-regexp)
 ("C-x \\" . toggle-input-method)
 ("M-s" . avy-goto-char)
 ("M-z" . avy-zap-up-to-char-dwim)
 ("M-m" . pop-to-mark-command)
 ("C-}" . mc/mark-next-like-this)
 ("C-{" . mc/mark-previous-like-this)
 ("C-|" . mc/mark-all-like-this-dwim)

 ("C-c C-e" . macrostep-expand)
 ("C-c Y" . youdao-dictionary-search-at-point)
 ("C-c y" . youdao-dictionary-search-at-point-tooltip))

;; 新建 window 并直接切换至新窗口
(global-set-key (kbd "C-x 2")
                (lambda()
                  (interactive)
                  (split-window-below)
                  (select-window (next-window))))
(global-set-key (kbd "C-x 3")
                (lambda()
                  (interactive)
                  (split-window-right)
                  (select-window (next-window))))

;; dired key
(define-key dired-mode-map "f" 'counsel-find-file)
(define-key dired-mode-map "F" 'find-name-dired)
(define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
(define-key dired-mode-map "." 'dired-hide-details-mode)
(define-key dired-mode-map "/" 'funs/dired-filter-show-match)
(define-key dired-mode-map "b"
  (lambda ()
    (interactive)
    (find-alternate-file "..")))
;;;###autoload
(defun funs/dired-filter-show-match ()
  "Only show filter file."
  (interactive)
  (call-interactively #'dired-mark-files-regexp)
  (command-execute "tk"))


;; view-mode key
(defvar view-mode-map) ;定义变量消除 flaycheck error
(with-eval-after-load 'view
  (bind-key "g" 'goto-line view-mode-map)
  (bind-key "h" 'backward-char view-mode-map)
  (bind-key "j" 'next-line view-mode-map)
  (bind-key "k" 'previous-line view-mode-map)
  (bind-key "l" 'forward-char view-mode-map)
  (bind-key "b" 'View-scroll-page-backward view-mode-map))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;; Org-mode ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(bind-keys :prefix-map org-map
           :prefix "C-c o"
           ("l" . org-store-link)
           ("a" . org-agenda)
           ("c" . org-capture)
           ("b" . org-switchb))

;; org-babel-map
(with-eval-after-load 'org
  (define-key org-babel-map (kbd "C-=") 'org-babel-mark-block))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package meow)
(defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-motion-overwrite-define-key
   '("j" . meow-next)
   '("k" . meow-prev))
  (meow-leader-define-key
   ;; SPC j/k will run the original command in MOTION state.
   '("j" . "H-j")
   '("k" . "H-k")
   ;; Use SPC (0-9) for digit arguments.
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-join)
   '("n" . meow-search)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-kill)
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-goto-line)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . mode-line-other-buffer)))
;; (meow-setup)
;; (meow-global-mode 1)


(provide 'keybindings)
;;; keybindings.el ends here
