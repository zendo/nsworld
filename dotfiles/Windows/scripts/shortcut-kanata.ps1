# Environment Variables
$startupFolder = [Environment]::GetFolderPath('Startup')

# Create WScript Shell Object
$WScriptShell = New-Object -ComObject WScript.Shell

# Create the shortcut
$Shortcut = $WScriptShell.CreateShortcut("$startupFolder\kanata-daemon.lnk")
$Shortcut.Description = "Kanata GUI"
$Shortcut.TargetPath = "$env:USERPROFILE\scoop\apps\kanata\current\kanata_windows_gui_winIOv2_x64.exe"
$Shortcut.Arguments = "-c minimal.kbd"
$Shortcut.WorkingDirectory = "$env:USERPROFILE\nsworld\dotfiles\kanata"
$Shortcut.Save()

Write-Output "Installation complete! Kanata GUI will start automatically with Windows."

Start-Process -FilePath $startupFolder
