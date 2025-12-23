#!/bin/sh

LAST_OUTPUT=""

while true; do
    CURRENT_OUTPUT=$(diskutil list external physical)
    
    if [[ "$CURRENT_OUTPUT" != "$LAST_OUTPUT" ]]; then
        clear
        echo "$CURRENT_OUTPUT"
        LAST_OUTPUT="$CURRENT_OUTPUT"
    fi
    
    sleep 2
done