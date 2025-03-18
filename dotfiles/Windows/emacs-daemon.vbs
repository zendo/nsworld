Set objShell = WScript.CreateObject("WScript.Shell")
objShell.Run "cmd /c runemacs --daemon", 0, True 
