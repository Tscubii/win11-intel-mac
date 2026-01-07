@echo off
setlocal enabledelayedexpansion

set "DISK_LABEL=BOOTCAMP"
set "USB_LABEL=Win11"

for %%a in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    vol %%a: 2>nul | find /i "%DISK_LABEL%" >nul
    if !errorlevel! equ 0 set "DISK_LETTER=%%a"
    
    vol %%a: 2>nul | find /i "%USB_LABEL%" >nul
    if !errorlevel! equ 0 set "USB_LETTER=%%a"
)

if defined DISK_LETTER (
    format %DISK_LETTER%: /fs:ntfs /v:BOOTCAMP /q /y
    
    if !errorlevel! equ 0 (
        if defined USB_LETTER (
            md %DISK_LETTER%:\mnt
            dism /Mount-Image /ImageFile:%USB_LETTER%:\sources\boot.wim /Index:2 /MountDir:%DISK_LETTER%:\mnt
            
            if !errorlevel! equ 0 (
                dism /Image:%DISK_LETTER%:\mnt /Add-Driver /Driver:%USB_LETTER%:\WinPEDriver /Recurse
                dism /Unmount-Image /MountDir:%DISK_LETTER%:\mnt /Commit
                
                echo Restarting in 10 seconds... (Press any key to restart now.)
                timeout /t 10 >nul
                wpeutil reboot
            )
        )
    )
)
