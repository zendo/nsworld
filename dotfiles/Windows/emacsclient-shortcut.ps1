function Create-Shortcut {
    param (
        [string]$SourceExe,
        [string]$ArgumentsToSourceExe,
        [string]$DestinationPath
    )
    $WshShell = New-Object -COMObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($DestinationPath)
    $Shortcut.TargetPath = $SourceExe
    $Shortcut.Arguments = $ArgumentsToSourceExe
    $Shortcut.Save()
}

# 创建桌面快捷方式
Create-Shortcut -SourceExe "$Home\scoop\apps\emacs\current\bin\emacsclientw.exe" `
                -ArgumentsToSourceExe '-c -n -a ""' `
                -DestinationPath "$Home\Desktop\GNU Emacs.lnk"

# 创建启动项快捷方式
# Win+r shell:startup
Create-Shortcut -SourceExe "$Home\scoop\apps\emacs\current\bin\runemacs.exe" `
                -ArgumentsToSourceExe "--daemon" `
                -DestinationPath "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\emacs-daemon.lnk"

# or VBScript
# $Startup = 'Set objShell = WScript.CreateObject("WScript.Shell")
# objShell.Run "cmd /c runemacs --daemon", 0, True
# '
# $Startup | Out-File "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\emacs-daemon.vbs"

Write-Output "Shortcuts is created successfully."
