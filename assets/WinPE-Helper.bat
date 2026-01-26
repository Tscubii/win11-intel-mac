@echo off
setlocal enabledelayedexpansion

set "USB_LABEL=Win11"

echo Finding the drive of %USB_LABEL%...
for %%i in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do (
    vol %%i: 2>nul | find /i "%USB_LABEL%" >nul
    if !ERRORLEVEL! equ 0 (
        echo %USB_LABEL% is drive %%i:
        set "USB_LETTER=%%i:"
    )
)

if defined USB_LETTER (
    if exist %USB_LETTER%\WindowsSupport\$WinPEDriver$ (
        echo Loading drivers into Windows Setup...
        
        for /r %USB_LETTER%\WindowsSupport\$WinPEDriver$\SerialIO %%i in (*.inf) do ( drvload %%i )
        for /r %USB_LETTER%\WindowsSupport\$WinPEDriver$\AppleDFR %%i in (*.inf) do ( drvload %%i )
        for /r %USB_LETTER%\WindowsSupport\$WinPEDriver$\AppleMultiTouchTrackPad64 %%i in (*.inf) do ( drvload %%i )
        for /r %USB_LETTER%\WindowsSupport\$WinPEDriver$\AppleMultiTouchTrackPadPro64 %%i in (*.inf) do ( drvload %%i )
    ) else ( echo Could not find %USB_LETTER%\WindowsSupport\$WinPEDriver$. )
) else ( echo Could not find the drive of %USB_LABEL%. )
