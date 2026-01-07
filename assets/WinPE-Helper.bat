@echo off
setlocal enabledelayedexpansion

set "DISK_LABEL=BOOTCAMP"
set "USB_LABEL=Win11"

for %%i in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do (
    vol %%i: 2>nul | find /i "%DISK_LABEL%" >nul
    if !errorlevel! equ 0 ( set "DISK_LETTER=%%i" )
    
    vol %%i: 2>nul | find /i "%USB_LABEL%" >nul
    if !errorlevel! equ 0 ( set "USB_LETTER=%%i" )
)

if defined DISK_LETTER (
    format %DISK_LETTER%: /fs:ntfs /v:BOOTCAMP /q /y
    
    if !errorlevel! equ 0 (
        if defined USB_LETTER (
            md %DISK_LETTER%:\Temp
            dism /Mount-Image /ImageFile:%USB_LETTER%:\sources\boot.wim /Index:2 /MountDir:%DISK_LETTER%:\Temp
            
            if !errorlevel! equ 0 (
                dism /Image:%DISK_LETTER%:\Temp /Add-Driver /Driver:%USB_LETTER%:\WinPEDriver /Recurse
                dism /Unmount-Image /MountDir:%DISK_LETTER%:\Temp /Commit
                rd %DISK_LETTER%:\Temp
                wpeutil reboot
            )
        )
    )
)
