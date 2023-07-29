#!/bin/bash

# Description:

# --------------------------------------------------------------------------------
# Global variables
# --------------------------------------------------------------------------------

# --------------------------------------------------------------------------------
# Functions
# --------------------------------------------------------------------------------

check_output_directory() {
    # Check if the output directory exists and is a directory
    if [[ ! -d "${output_directory}" ]]; then
        if [[ -f "${output_directory}" ]]; then
            printf "!!! Output directory exists but is a file.\n" >&2
            exit 1
        else
            printf "!!! Output directory does not exist.\n" >&2
            printf "Want to create it? (y/n): "
            read -r answer

            if [[ "${answer}" == "y" ]]; then
                mkdir -p "${output_directory}"
            else
                printf "Aborting.\n"
                exit 1
            fi
        fi
    fi
}

check_input_list() {
    # Check if the input list exists and is a .txt file
    if [[ ! -f "${list_directory}" ]]; then
        printf "!!! Input list does not exist.\n" >&2
        exit 1
    elif [[ "${list_directory}" != *.txt ]]; then
        printf "!!! Input list is not a .txt file.\n" >&2
        exit 1
    fi
}

print_usage() {
    printf "Usage:    ./list_to_folders.sh <input_list> <output_directory>\n"
    printf "    <input_list>        : path to the input list\n"
    printf "    <output_directory>  : path to the output directory\n"
}

# --------------------------------------------------------------------------------
# Main
# --------------------------------------------------------------------------------

# Make sure the correct number of arguments were supplied
if [[ $# -ne 2 ]]; then
    printf "!!! Invalid number of arguments.\n" >&2
    print_usage
    exit 1
fi

list_directory="$1"
output_directory="$2"

check_input_list "${list_directory}"

check_output_directory "${output_directory}"

# Read the input list and create the directories
while IFS= read -r folder_name; do # IFS= prevents leading/trailing whitespaces from being trimmed
    if [[ -n "${folder_name}" ]]; then # -n checks if the string is not empty
        mkdir -p "${output_directory}/${folder_name}"
        echo "Created folder: ${output_directory}/${folder_name}"
    fi
done <"${list_directory}"