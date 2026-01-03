#!/bin/sh

while true; do
    read -rp "Enter the disk you took note of in Watch-USB.command: " DISK
    
    # Check if the disk exists and is not a partition.
    if [[ "$(diskutil info "$DISK" 2>/dev/null | awk '/Whole:/ && !/Part/ {print $NF}')" == "Yes" ]]; then
        diskutil info "$DISK"
        read -rp "Info about $DISK is displayed above. Format $DISK? [y/N] " ANSWER
        
        case "$ANSWER" in
            [Yy]*)
                diskutil partitionDisk -noEFI "$DISK" 2 GPT ExFAT Win11 R "MS-DOS FAT12" UEFI_NTFS 1M
                break;;
            *)
                echo "Aborted. Retrying...";;
        esac
    else
        echo "$DISK is not a disk. Retrying..."
    fi

done
