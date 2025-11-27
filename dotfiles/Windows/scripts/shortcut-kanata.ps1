# Environment Variables
$startupFolder = [Environment]::GetFolderPath('Startup')

# Create WScript Shell Object
$WScriptShell = New-Object -ComObject WScript.Shell

# Create the shortcut
$Shortcut = $WScriptShell.CreateShortcut("$startupFolder\kanata-daemon.lnk")
$Shortcut.Description = "Kanata GUI"
$Shortcut.TargetPath = "kanata_windows_gui_winIOv2_x64"
$Shortcut.Arguments = "-c minimal.kbd"
$Shortcut.WorkingDirectory = "$Home\nsworld\dotfiles\kanata"
$Shortcut.Save()

Write-Output "Installation complete! Kanata GUI will start automatically with Windows."

Start-Process -FilePath $startupFolder
