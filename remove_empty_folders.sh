#!/bin/bash

# Description: Remove all empty folders in a given directory
# Usage: remove_empty_folders.sh <directory>

# ----------------------------------------------------------------
# Functions
# ----------------------------------------------------------------

remove_empty() {
    # Loop through all files and folders in the given directory
    for file in "${1}"/*; do
        # Check if the current file is a directory
        if [[ -d "${file}" ]]; then
            # Check if the current directory is empty
            if [[ -z "$(ls -A "${file}")" ]]; then
                # Remove the current directory
                rm -rf "${file}"
            else
                # Remove all empty folders in the current directory
                remove_empty "${file}"
            fi
        fi
    done
}

# ----------------------------------------------------------------
# Main
# ----------------------------------------------------------------

# Check if a directory was given
if [ $# -eq 0 ]; then
    echo "No directory given"
    exit 1
fi

# Check if the given directory exists
if [ ! -d "$1" ]; then
    echo "Directory $1 does not exist"
    exit 1
fi

# Remove all empty folders
remove_empty "$1"
remove_empty "$1"
