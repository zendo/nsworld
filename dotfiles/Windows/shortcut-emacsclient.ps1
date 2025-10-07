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

# C:\Program Files
$programs = [Environment]::GetFolderPath("ProgramFiles")
# Win+r shell:startup
$startupFolder = [Environment]::GetFolderPath('Startup')

# 创建桌面快捷方式
# ((fullscreen . maximized))
# ((top . 0)(left . -1)(height . 44)(width . 80))
Create-Shortcut -SourceExe "emacsclientw.exe" `
                -ArgumentsToSourceExe '-c -n -a "" -F "((top . 0)(left . -1)(height . 44)(width . 80))"' `
                -DestinationPath "$Home\Desktop\GNU Emacs.lnk"

# 创建启动项快捷方式
Create-Shortcut -SourceExe "runemacs.exe" `
                -ArgumentsToSourceExe "--daemon" `
                -DestinationPath "$startupFolder\emacs-daemon.lnk"

# or VBScript
# $Startup = 'Set objShell = WScript.CreateObject("WScript.Shell")
# objShell.Run "cmd /c runemacs --daemon", 0, True
# '
# $Startup | Out-File "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\emacs-daemon.vbs"

# 任务栏图标重复
# pin runemacs.exe
# shift+右键：属性-目标，改为以上桌面快捷方式一样的
# Win+r shell:User Pinned\Taskbar

Write-Output "Shortcuts is created successfully."

Start-Process -FilePath $startupFolder
