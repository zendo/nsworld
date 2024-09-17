;;; Package --- Summary
;;; Commentary:
;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el
;;; Code:

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.

(package! crux
  :recipe (:host github :repo "bbatsov/crux"))

(package! rotate
  :recipe (:host github :repo "daichirata/emacs-rotate"))

(package! easy-kill
  :recipe (:host github :repo "leoliu/easy-kill"))

(package! smart-region
  :recipe (:host github :repo "uk-ar/smart-region"))

(package! avy-zap
  :recipe (:host github :repo "cute-jumper/avy-zap"))

(package! iedit
  :recipe (:host github :repo "victorhge/iedit"))

(package! fanyi
  :recipe (:host github :repo "condy0919/fanyi.el"))

(package! ialign
  :recipe (:host github :repo "mkcms/interactive-align"))

(package! goto-last-change)
;; :recipe (:host github :repo "camdez/goto-last-change"))

(package! ctrlf)

(package! just-mode)

(package! deadgrep)
