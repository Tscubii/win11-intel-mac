@echo off
setlocal enabledelayedexpansion

set "USB_LABEL=Win11"
set "HDD_LABEL=BOOTCAMP"

echo Finding the drive of %USB_LABEL%...
for %%i in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do (
    if not defined USB_LETTER (
        vol %%i: 2>nul | find /i "%USB_LABEL%" >nul
            if !ERRORLEVEL! equ 0 (
            echo %USB_LABEL% is drive %%i:
            set "USB_LETTER=%%i:"
            goto BOOTWIM
        )
    )
)

echo Finding the drive of %HDD_LABEL%...
for %%i in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do (
    if not defined HDD_LETTER (
        vol %%i: 2>nul | find /i "%HDD_LABEL%" >nul
        if !ERRORLEVEL! equ 0 (
            echo %HDD_LABEL% is drive %%i:
            set "HDD_LETTER=%%i:"
            goto BOOTWIM
        )
    )
)

if not defined USB_LETTER ( echo ERROR: Could not find the drive of %USB_LABEL%. Cannot continue. & goto SHUTDOWN )
if not defined HDD_LETTER ( echo ERROR: Could not find the drive of %HDD_LABEL%. Cannot continue. & goto SHUTDOWN )

:BOOTWIM
if not exist "%HDD_LETTER%\Mount" (
    echo Formatting %HDD_LABEL% (%HDD_LETTER%) to NTFS...
    format %HDD_LETTER% /fs:NTFS /v:BOOTCAMP /q /y
    
    echo Creating mount folder...
    md "%HDD_LETTER%\Mount"
    
    echo Mounting boot.wim...
    dism /Mount-Image /ImageFile:"%USB_LETTER%\sources\boot.wim" /Index:2 /MountDir:"%HDD_LETTER%\Mount"
    
    echo Adding drivers to boot.wim...
    dism /Image:"%HDD_LETTER%\Mount" /Add-Driver /Driver:"%USB_LETTER%\WindowsSupport\$WinPEDriver$" /Recurse
    
    echo Saving and unmounting boot.wim...
    dism /Unmount-Image /MountDir:"%HDD_LETTER%\Mount" /Commit
    
    echo INFO: boot.wim prepared successfully. Boot from USB again to continue.
    goto SHUTDOWN
) else (
    echo INFO: Found mount folder, assuming boot.wim already prepared. Self-deleting...
    (goto) 2>nul & del "%~f0"
    goto EOF
)

:SHUTDOWN
echo Shutting down in 10 seconds...
ping -n 11 127.0.0.1 >nul
wpeutil shutdown

:EOF
