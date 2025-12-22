# How to Install Windows 11 on an Intel Mac (WIP)

A guide on how to clean install Windows 11 on an Intel-based Mac. No Windows 10 shenanigans.

## What You Need

* 16 GB+ USB
* [Windows partition](https://support.apple.com/guide/disk-utility/partition-a-physical-disk-dskutl14027/mac#:~:text=Add%20a%20partition,finishes%2C%20click%20Done.) (how-to instructions)
    * Name: BOOTCAMP
    * Format: ExFAT
    * Size: 64 GB+
* [Windows 11 ISO](https://www.microsoft.com/en-us/software-download/windows11) (the x64 `.iso` file)
* [Windows support software](https://support.apple.com/en-us/102465#:~:text=Download%20the%20Windows,Boot%20Camp%20Assistant.) (how-to instructions)
    * Save it to your internal disk
* [Assets.zip](https://github.com/Tscubii/win11-intel-mac/raw/refs/heads/main/Assets.zip) (direct download)
* [bootx64.efi](https://github.com/pbatard/uefi-ntfs/releases/latest/download/bootx64.efi) (direct download)
* [exfat_x64.efi](https://github.com/pbatard/EfiFs/releases/latest/download/exfat_x64.efi) (direct download)

Put the files in an easily accessible folder (e.g., one on the desktop called `Main`).

## Instructions

### Section I - Prep Work

First we identify, format, and copy files to the USB.

1. Extract the Assets `.zip` and enter the new folder
2. Open `Watch-USB.command` and prepare to watch for changes
3. Insert the USB and take note of the newest disk's identifier (e.g., disk2)
4. Press Ctrl+C and close `Watch-USB.command`
5. Open `Format-USB.command` and follow the prompts
6. Close `Format-USB.command`
7. Mount the ISO and copy everything from it to the Win11 volume
8. Enter the `WindowsSupport` folder and copy everything from it to the Win11 volume
9. Enter the `Assets` folder and copy `Bypass-Requirements.reg` to the Win11 volume
10. In the UEFI_NTFS volume, create the folder structure and copy the two `.efi` files as shown below:

```
EFI/
|-- Boot/
|   `-- bootx64.efi
`-- Rufus/
    `-- exfat_x64.efi
```

### Section II - Installation

Then we boot from the USB and install Windows 11.

1. Reboot the Mac, hold Option, and select UEFI_NTFS
2. Press Shift+F10, run `reg import C:\Bypass-Requirements.reg`, close Command Prompt, and continue with the installation

### Troubleshooting

#### WIP

1. 
