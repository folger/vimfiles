@echo off
SET vimPath=G:\vim_min\vim74\gvim.exe
 
rem add it for all file types
@reg add "HKEY_CLASSES_ROOT\*\shell\Open with Vim"         /t REG_SZ /v "" /d "Open with Vim"   /f
@reg add "HKEY_CLASSES_ROOT\*\shell\Open with Vim"         /t REG_EXPAND_SZ /v "Icon" /d "%vimPath%,0" /f
@reg add "HKEY_CLASSES_ROOT\*\shell\Open with Vim\command" /t REG_SZ /v "" /d "%vimPath% \"%%1\"" /f
 
rem add it for folders
@reg add "HKEY_CLASSES_ROOT\Folder\shell\Open with Vim"         /t REG_SZ /v "" /d "Open with Vim"   /f
@reg add "HKEY_CLASSES_ROOT\Folder\shell\Open with Vim"         /t REG_EXPAND_SZ /v "Icon" /d "%vimPath%,0" /f
@reg add "HKEY_CLASSES_ROOT\Folder\shell\Open with Vim\command" /t REG_SZ /v "" /d "%vimPath% \"%%1\"" /f
pause
