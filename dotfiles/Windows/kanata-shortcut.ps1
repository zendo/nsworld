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
Create-Shortcut -SourceExe "kanata_gui.exe" `
                -ArgumentsToSourceExe "-c $Home\nsworld\dotfiles\kanata\minimal.kbd" `
                -DestinationPath "$Home\Desktop\Kanata Gui.lnk"

# 创建启动项快捷方式
# Win+r shell:startup
$startupFolder = [Environment]::GetFolderPath('Startup')
Create-Shortcut -SourceExe "kanata_gui.exe" `
                -ArgumentsToSourceExe "-c $Home\nsworld\dotfiles\kanata\minimal.kbd" `
                -DestinationPath "$startupFolder\kanata-daemon.lnk"

Write-Output "Shortcuts is created successfully."
