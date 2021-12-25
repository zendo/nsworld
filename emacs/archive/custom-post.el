(global-set-key (kbd "C-z") 'nil) ;unbind C-zzzzz
(global-set-key [remap kill-buffer] #'kill-this-buffer)

;; crux
(use-package crux
  :bind (("C-k" . crux-smart-kill-line)
         ("C-x 4 x" . crux-swap-windows)))
;; (with-eval-after-load 'rect
;;   (global-set-key [(control return)] #'crux-smart-open-line))
(global-set-key [(control shift return)] #'crux-smart-open-line-above)

(bind-keys*
 ("C-." . company-complete) ;; counsel-imenu
 ("C-\\" . align-regexp)
 ("C-x \\" . toggle-input-method)
 ("M-m" . pop-to-mark-command)
 ("C-}" . mc/mark-next-like-this)
 ("C-{" . mc/mark-previous-like-this)
 ("C-|" . mc/mark-all-like-this-dwim))

;; nixos
(use-package nix-mode
  :mode "\\.nix\\'")






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


;;----------------------------------------------------------------------------
;; stop using mouse minibuffer
;;----------------------------------------------------------------------------
;;;###autoload
(defun stop-using-minibuffer ()
  "Kill the minibuffer."
  (when (and (>= (recursion-depth) 1) (active-minibuffer-window))
    (abort-recursive-edit)))
(add-hook 'mouse-leave-buffer-hook 'stop-using-minibuffer)

;;----------------------------------------------------------------------------
;; Pop until marker actually moves
;;----------------------------------------------------------------------------
;;;###autoload
(defun modi/multi-pop-to-mark (orig-fun &rest args)
  "Call ORIG-FUN until the cursor moves.Try the repeated popping up to 10 times."
  (let ((p (point)))
    (dotimes (i 10)
      (when (= p (point))
        (apply orig-fun args)))))
(advice-add 'pop-to-mark-command :around
            #'modi/multi-pop-to-mark)

;;----------------------------------------------------------------------------
;; align
;;----------------------------------------------------------------------------
;;;###autoload
(defun zendo/align-whitespace (start end)
  "Align columns by whitespace"
  (interactive "r")
  (align-regexp start end
                "\\(\\s-*\\)\\s-" 1 0 t))

(defun zendo/align-& (start end)
  "Align columns by ampersand"
  (interactive "r")
  (align-regexp start end
                "\\(\\s-*\\)&" 1 1 t))

;;----------------------------------------------------------------------------
;; space to newline
;;----------------------------------------------------------------------------
;;;###autoload
(defun zendo/space-to-newline ()
  "Replace space sequence to a newline char.
Works on current block or selection.

URL `http://ergoemacs.org/emacs/emacs_space_to_newline.html'
Version 2017-08-19"
  (interactive)
  (let* ( $p1 $p2 )
    (if (use-region-p)
        (progn
          (setq $p1 (region-beginning))
          (setq $p2 (region-end)))
      (save-excursion
        (if (re-search-backward "\n[ \t]*\n" nil "move")
            (progn (re-search-forward "\n[ \t]*\n")
                   (setq $p1 (point)))
          (setq $p1 (point)))
        (re-search-forward "\n[ \t]*\n" nil "move")
        (skip-chars-backward " \t\n" )
        (setq $p2 (point))))
    (save-excursion
      (save-restriction
        (narrow-to-region $p1 $p2)
        (goto-char (point-min))
        (while (re-search-forward " +" nil t)
          (replace-match "\n" ))))))
