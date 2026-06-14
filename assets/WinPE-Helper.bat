@echo off
setlocal enabledelayedexpansion

set "USB_LABEL=Win11"
set "HDD_LABEL=BOOTCAMP"

echo Finding the drive of %USB_LABEL%...
for %%i in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do (
    vol %%i: 2>nul | find /i "%USB_LABEL%" >nul
    if !ERRORLEVEL! equ 0 (
        echo %USB_LABEL% is drive %%i:
        set "USB_LETTER=%%i:"
    )
)

echo Finding the drive of %HDD_LABEL%...
for %%i in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do (
    vol %%i: 2>nul | find /i "%HDD_LABEL%" >nul
    if !ERRORLEVEL! equ 0 (
        echo %HDD_LABEL% is drive %%i:
        set "HDD_LETTER=%%i:"
    )
)

if defined USB_LETTER (
    if defined HDD_LETTER (
        echo Formatting %HDD_LABEL% (%HDD_LETTER%) to NTFS...
        format %HDD_LETTER% /fs:NTFS /v:BOOTCAMP /q /y

        echo Mounting boot.wim...
        md %HDD_LETTER%\Mount
        dism /Mount-Image /ImageFile:%USB_LETTER%\sources\boot.wim /Index:2 /MountDir:%HDD_LETTER%\Mount

        echo Adding drivers to boot.wim...
        dism /Image:%HDD_LETTER%\Mount /Add-Driver /Driver:%USB_LETTER%\WindowsSupport\$WinPEDriver$ /Recurse

        echo Saving and unmounting boot.wim...
        dism /Unmount-Image /MountDir:%HDD_LETTER%\Mount /Commit
        rd %HDD_LETTER%\Mount
    ) else ( echo Could not find the drive of %HDD_LABEL%. )
) else ( echo Could not find the drive of %USB_LABEL%. )
