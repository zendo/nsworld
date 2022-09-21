set myDIR=%APPDATA%\.emacs.d
IF not exist %myDIR% (mkdir %myDIR%)

mklink /D %APPDATA%\.emacs.d\elisp %HOMEPATH%\nsworld\emacs\elisp
mklink /H %APPDATA%\.emacs.d\init.el %HOMEPATH%\nsworld\emacs\init.el
mklink /H %APPDATA%\.emacs.d\early-init.el %HOMEPATH%\nsworld\emacs\early-init.el

mklink /J %APPDATA%\.doom.d %HOMEPATH%\nsworld\emacs\doom
