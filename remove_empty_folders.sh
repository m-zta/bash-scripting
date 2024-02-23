#!/bin/bash

# Description: Remove all empty folders in a given directory
# Usage: remove_empty_folders.sh <directory>
#
# NOTE: Not working as expected yet

# ----------------------------------------------------------------
# Functions
# ----------------------------------------------------------------

remove_empty() {
    # Check if directory is empty and delete if so
    if [[ -z ${1} ]]; then
        rmdir "${1}"
    else
        # Loop through all files and folders in the given directory
        for file in "${1}"/*; do
            printf "File: %s\n" "${file}"
            # Check if the current file is a directory
            if [[ -d "${file}" ]]; then
                remove_empty "${file}"
                if [[ -z $(ls -A "${file}") ]]; then
                    printf "Delete: %s\n" "${file}"
                    rmdir "${file}"
                fi
            fi
        done
    fi
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
