# How to Install Windows 11 on an Intel Mac (WIP)

A guide on how to clean install Windows 11 on an Intel-based Mac. No Windows 10 or WIM splitting shenanigans.

This was tested on a MacBook Pro (16-inch, 2019) running macOS Sequoia 15.7.3.

## What You Need - All

* 16 GB+ USB
* [Windows partition](https://support.apple.com/guide/disk-utility/partition-a-physical-disk-dskutl14027/mac#:~:text=Add%20a%20partition,finishes%2C%20click%20Done.) (how-to instructions)
    * Name: BOOTCAMP
    * Format: ExFAT
    * Size: 64 GB+
        * Set first to prevent lockout
* [Windows 11 ISO](https://www.microsoft.com/en-us/software-download/windows11) (the x64 `.iso` file)
* [Windows support software](https://support.apple.com/en-us/102465#:~:text=Download%20the%20Windows,Boot%20Camp%20Assistant.) (how-to instructions)
    * Save it to the `Downloads` folder
* [win11-intel-mac-main.zip](https://github.com/Tscubii/win11-intel-mac/archive/refs/heads/main.zip) (direct download)
* [bootx64.efi](https://github.com/pbatard/uefi-ntfs/releases/latest/download/bootx64.efi) (direct download)
* [exfat_x64.efi](https://github.com/pbatard/EfiFs/releases/latest/download/exfat_x64.efi) (direct download)

## What You Need - T2

* [Secure Boot set to No Security and Allowed Boot Media set to Allow booting from external or removable media](https://support.apple.com/en-us/102522#:~:text=Open%20Startup%20Security,enter%20its%20password.) (how-to instructions)
    * Full Security prompts for an Internet check which always fails.
    * Medium Security prompts for a macOS reinstall.

Revert these once you reach the Windows 11 desktop.

## What You Need - MacBook

* External keyboard and mouse
    * Windows 11 Setup doesn't like it when $WinPEDriver$ has drivers in them

Put the files in an easily accessible folder (e.g., one on the desktop called `Temp`).

## Instructions

### Section I - Prep Work

First we identify, format, and copy files to the USB.

1. Enter the `win11-intel-mac-main` folder, right-click the `assets` folder, and click "New Terminal at Folder"
2. Run `chmod u+x *.command`
3. Run `./Watch-USB.command` and prepare to watch for changes
5. Insert the USB and take note of the disk's identifier (e.g., disk2)
6. Press Ctrl+C to stop the script
7. Run `./Format-USB.command` and follow the prompts
8. Close Terminal
9. Mount the ISO and copy everything from it to the Win11 volume
10. Enter the `WindowsSupport` folder and copy everything from it to the Win11 volume
11. Enter the `assets` folder and copy `AutoUnattend.xml` to the Win11 volume (replace if asked)
12. Rename `$WinPEDriver$` to `WinPEDriver`
13. In the UEFI_NTFS volume, create the folder structure and copy the two `.efi` files as shown below:

```
EFI/
|-- Boot/
|   `-- bootx64.efi
`-- Rufus/
    `-- exfat_x64.efi
```

### Section II - Installation

Then we boot from the USB and install Windows 11.

1. Reboot the Mac, hold Option, and select EFI Boot (if there's two, select the rightmost option)
2. Proceed with the installation
    * Select the BOOTCAMP partition, click "Format Partition", click "Refresh", and click "Next"
