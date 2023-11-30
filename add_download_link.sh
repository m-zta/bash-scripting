#!/bin/bash

# ====================================================================
# Constants
# ====================================================================

DESCRIPTION="Description: This script is a tool for my personal use.\nUsage: add_download_link.sh <directory> <url>"

# ====================================================================
# Functions
# ====================================================================

# Check if the directory exists. If not, print the usage and exit.
check_directory() {
    if [ ! -d "$1" ]; then
        printf "Error: Directory does not exist.\n"
        printf "$DESCRIPTION\n"
        exit 1
    fi
}

check_url() {
    if [[ ! $1 =~ ^https?:// ]]; then
        printf "Error: Invalid URL.\n"
        printf "$DESCRIPTION\n"
        exit 1
    fi
}

# ====================================================================
# Main
# ====================================================================
#
# Check if the number of arguments is correct. If not, print the usage and exit.
if [ $# -ne 2 ]; then
    printf "Error: Wrong number of arguments.\n"
    printf "$DESCRIPTION\n"
    exit 1
fi

directory=$1
url=$2

check_directory $directory
check_url $url

touch $directory/README.txt
echo "Download link:\n ${url}" >> $directory/README.txt
printf "Succcessfully added download link to ${directory}.\n"

exit 0

