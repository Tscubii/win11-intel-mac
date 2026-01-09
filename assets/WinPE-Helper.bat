@echo off
setlocal enabledelayedexpansion

set "DISK_LABEL=BOOTCAMP"
set "USB_LABEL=Win11"

echo Finding the drives of %DISK_LABEL% and %USB_LABEL%...
for %%i in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do (
    vol %%i: 2>nul | find /i "%DISK_LABEL%" >nul
    if !ERRORLEVEL! equ 0 (
        echo %DISK_LABEL% is drive %%i:
        set "DISK_LETTER=%%i"
    )
    
    vol %%i: 2>nul | find /i "%USB_LABEL%" >nul
    if !ERRORLEVEL! equ 0 (
        echo %USB_LABEL% is drive %%i:
        set "USB_LETTER=%%i"
    )
)

if defined DISK_LETTER (
    echo Formatting %DISK_LABEL% (%DISK_LETTER%:) to NTFS...
    format %DISK_LETTER%: /fs:ntfs /v:BOOTCAMP /q /y
    
    if !ERRORLEVEL! equ 0 (
        if defined USB_LETTER (
            echo Mounting Windows Setup...
            md %DISK_LETTER%:\Temp
            dism /Mount-Image /ImageFile:%USB_LETTER%:\sources\boot.wim /Index:2 /MountDir:%DISK_LETTER%:\Temp
            
            if !ERRORLEVEL! equ 0 (
                echo Adding drivers to Windows Setup...
                dism /Image:%DISK_LETTER%:\Temp /Add-Driver /Driver:%USB_LETTER%:\WinPEDriver /Recurse
                
                echo Saving Windows Setup...
                dism /Unmount-Image /MountDir:%DISK_LETTER%:\Temp /Commit
                
                if !ERRORLEVEL! equ 0 (
                    echo Mounting Windows 11 Pro...
                    dism /Mount-Image /ImageFile:%USB_LETTER%:\sources\install.wim /Index:6 /MountDir:%DISK_LETTER%:\Temp
                    
                    if !ERRORLEVEL! equ 0 (
                        echo Adding drivers to Windows 11 Pro...
                        dism /Image:%DISK_LETTER%:\Temp /Add-Driver /Driver:%USB_LETTER%:\WinPEDriver /Recurse
                        
                        echo Saving Windows 11 Pro...
                        dism /Unmount-Image /MountDir:%DISK_LETTER%:\Temp /Commit
                        
                        if !ERRORLEVEL! equ 0 (
                            echo Windows Setup will now restart!
                            wpeutil reboot
                        ) else ( echo Couldn't save Windows 11 Pro! This really shouldn't have happened... )
                    ) else ( echo Couldn't mount Windows 11 Pro! This really shouldn't have happened... )
                ) else ( echo Couldn't save Windows Setup! This really shouldn't have happened... )
            ) else ( echo Couldn't mount Windows Setup! This really shouldn't have happened... )
        ) else ( echo Couldn't find the drive of %USB_LABEL%! Was the volume renamed? )
    ) else ( echo Couldn't format %DISK_LABEL% (%DISK_LETTER%:) to NTFS! This really shouldn't have happened... )
) else ( echo Couldn't find the drive of %DISK_LABEL%! Was the partition named correctly? )
