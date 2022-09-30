set myDIR=%APPDATA%\.emacs.d
IF not exist %myDIR% (mkdir %myDIR%)

mklink /D %APPDATA%\.emacs.d\elisp %HOMEPATH%\nsworld\dotfiles\emacs\elisp
mklink /H %APPDATA%\.emacs.d\init.el %HOMEPATH%\nsworld\dotfiles\emacs\init.el
mklink /H %APPDATA%\.emacs.d\early-init.el %HOMEPATH%\nsworld\dotfiles\emacs\early-init.el

mklink /J %APPDATA%\.doom.d %HOMEPATH%\nsworld\dotfiles\emacs\doom
