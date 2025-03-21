param ( [string]$SourceExe, [string]$ArgumentsToSourceExe, [string]$DestinationPath )

$DestinationPath = "$Home\Desktop\GNU Emacs.lnk"
$SourceExe = "$Home\scoop\apps\emacs\current\bin\emacsclientw.exe"
$ArgumentsToSourceExe = "-c -n -a """

$WshShell = New-Object -COMObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($DestinationPath)
$Shortcut.TargetPath = $SourceExe
$Shortcut.Arguments = $ArgumentsToSourceExe
$Shortcut.Save()

# Win+r shell:startup
Copy-Item ".\emacs-daemon.vbs" "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\"

Write-Output "$DestinationPath is created successfully."
