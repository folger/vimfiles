@echo off
SET nppath=D:\Notepad++\Notepad++.exe
 
rem add it for all file types
@reg add "HKEY_CLASSES_ROOT\*\shell\Open with Notepad++"         /t REG_SZ /v "" /d "Open with NotepadPl&us"   /f
@reg add "HKEY_CLASSES_ROOT\*\shell\Open with Notepad++"         /t REG_EXPAND_SZ /v "Icon" /d "%nppath%,0" /f
@reg add "HKEY_CLASSES_ROOT\*\shell\Open with Notepad++\command" /t REG_SZ /v "" /d "%nppath% \"%%1\"" /f
 
rem add it for folders
@reg add "HKEY_CLASSES_ROOT\Folder\shell\Open with Notepad++"         /t REG_SZ /v "" /d "Open with NotepadPl&us"   /f
@reg add "HKEY_CLASSES_ROOT\Folder\shell\Open with Notepad++"         /t REG_EXPAND_SZ /v "Icon" /d "%nppath%,0" /f
@reg add "HKEY_CLASSES_ROOT\Folder\shell\Open with Notepad++\command" /t REG_SZ /v "" /d "%nppath% \"%%1\"" /f
pause
