#!/bin/sh

LAST_OUTPUT=""

while true; do
    CURRENT_OUTPUT=$(diskutil list external physical)
    if [[ "$CURRENT_OUTPUT" != "$LAST_OUTPUT" ]]; then clear;
        echo "$CURRENT_OUTPUT"
        LAST_OUTPUT="$CURRENT_OUTPUT"
    fi
    
    echo "Finding USB drives... Press any key to stop."
    if [[ read -t 1 -n 1 -s ]]; then break; fi
done

while true; do
    read -rp "Enter the disk's identifier (e.g., disk2): " DISK
    
    # Check if the disk exists and is not a partition.
    if [[ "$(diskutil info "$DISK" 2>/dev/null | awk '/Whole:/ && !/Part/ {print $NF}')" == "Yes" ]]; then
        diskutil info "$DISK"
        read -rp "Info about $DISK is displayed above. Format $DISK? [y/N] " ANSWER
        
        case "$ANSWER" in
            [Yy]*) diskutil partitionDisk -noEFI "$DISK" 2 GPT ExFAT Win11 R "MS-DOS FAT12" UEFI_NTFS 1Mi; echo "Done."; break;;
            *) echo "Aborted. Retrying...";;
        esac
    else echo "$DISK is not a disk. Retrying..."; fi
done
