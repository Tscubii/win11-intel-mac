@echo off
setlocal enabledelayedexpansion

set "USB_LABEL=Win11"
set "HDD_LABEL=BOOTCAMP"

echo Finding %USB_LABEL%...
for %%i in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do (
    vol %%i: 2>nul | find /i "%USB_LABEL%" >nul
    if !ERRORLEVEL! equ 0 (
        echo Found %USB_LABEL% (%%i:).
        set "USB_LETTER=%%i:"
    )
)
if not defined USB_LETTER ( echo ERROR: Could not find %USB_LABEL%. Cannot continue. & goto SHUTDOWN )

echo Finding %HDD_LABEL%...
for %%i in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do (
    vol %%i: 2>nul | find /i "%HDD_LABEL%" >nul
    if !ERRORLEVEL! equ 0 (
        echo Found %HDD_LABEL% (%%i:).
        set "HDD_LETTER=%%i:"
    )
)
if not defined HDD_LETTER ( echo ERROR: Could not find %HDD_LABEL%. Cannot continue. & goto SHUTDOWN )

if not exist "%HDD_LETTER%\Mount" (
    echo Formatting %HDD_LABEL% (%HDD_LETTER%) to NTFS...
    format %HDD_LETTER% /fs:ntfs /v:%HDD_LABEL% /q /y
    
    echo Creating mount folder...
    if not exist "%HDD_LETTER%\Mount" ( md "%HDD_LETTER%\Mount" )
    
    echo Mounting boot.wim...
    dism /Mount-Image /ImageFile:"%USB_LETTER%\sources\boot.wim" /Index:2 /MountDir:"%HDD_LETTER%\Mount"
    if !ERRORLEVEL! neq 0 ( echo ERROR: Could not mount boot.wim. Cannot continue. & goto SHUTDOWN )
    
    echo Adding drivers...
    dism /Image:"%HDD_LETTER%\Mount" /Add-Driver /Driver:"%USB_LETTER%\WindowsSupport\$WinPEDriver$" /Recurse
    if !ERRORLEVEL! neq 0 (
        echo ERROR: Could not add drivers. Cannot continue. Discarding...
        dism /Unmount-Image /MountDir:"%HDD_LETTER%\Mount" /Discard
        goto SHUTDOWN
    )
    
    echo Saving and unmounting...
    dism /Unmount-Image /MountDir:"%HDD_LETTER%\Mount" /Commit
    
    echo INFO: boot.wim prepared successfully. Boot from USB again to continue.
    goto SHUTDOWN
) else (
    echo INFO: Found boot.wim remnants. Discarding and self-deleting...
    dism /Unmount-Image /MountDir:"%HDD_LETTER%\Mount" /Discard >nul 2>&1
    goto 2>nul & del "%~f0"
    goto EOF
)

:SHUTDOWN
echo Shutting down in 10 seconds...
ping -n 11 127.0.0.1 >nul
wpeutil shutdown

:EOF
