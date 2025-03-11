@echo off
echo Starting...

setx HOME %USERPROFILE%

set myDIR=%USERPROFILE%\.config\emacs
IF not exist %myDIR% (mkdir %myDIR%)

mklink /H %USERPROFILE%\.config\emacs\all-emacs.org %HOMEPATH%\nsworld\dotfiles\org\all-emacs.org

REM https://github.com/badrelmers/RefrEnv
REM curl -O https://raw.githubusercontent.com/badrelmers/RefrEnv/refs/heads/main/refrenv.bat
REM iwr "https://raw.githubusercontent.com/badrelmers/RefrEnv/refs/heads/main/refrenv.bat" -O refrenv.bat
call "%~dp0refrenv.bat"
timeout /t 2 /nobreak >nul
emacs --batch -l org --eval "(setq vc-follow-symlinks nil)" --eval "(org-babel-tangle-file \"~/.config/emacs/all-emacs.org\")"

REM #############################################################################
REM ### Doom Emacs ##############################################################
REM #############################################################################
rem set doomDIR=%USERPROFILE%\.config\doom
rem IF not exist %doomDIR% (mkdir %doomDIR%)

rem mklink /H %USERPROFILE%\.config\doom\config.org %HOMEPATH%\nsworld\dotfiles\org\doom-emacs.org

rem call "%~dp0refrenv.bat"
rem timeout /t 2 /nobreak >nul
rem emacs --batch -l org --eval "(setq vc-follow-symlinks nil)" --eval "(org-babel-tangle-file \"~/.config/doom/config.org\")"
REM #############################################################################

echo Done!
pause
exit
