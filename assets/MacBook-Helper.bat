@echo off
setlocal enabledelayedexpansion

set "USB_LABEL=Win11"

echo Finding the drive of %USB_LABEL%...
for %%i in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do (
    vol %%i: 2>nul | find /i "%USB_LABEL%" >nul
    if !ERRORLEVEL! equ 0 (
        echo %USB_LABEL% is drive %%i
        set "USB_LETTER=%%i"
    )
)

if defined USB_LETTER (
    if exist %USB_LETTER%:\WindowsSupport (
        set "DRV_FOLDER=%USB_LETTER%:\WindowsSupport"
        
        echo Adding drivers to Windows Setup...
        for /r %DRV_FOLDER% %%i in (*.inf) do ( drvload %%i )
    ) else ( echo Couldn't find %USB_LETTER%:\WindowsSupport. )
) else ( echo Couldn't find the drive of %USB_LABEL%. )
