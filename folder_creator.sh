#!/bin/bash

DESCRIPTION="Easily create multiple folders inside a directory."

# TODO:
# - Add a help message
# - Optimize the structure of the script

# ==============================================================================
# Functions
# ==============================================================================

# Check if a folder name is valid
# @param $1: folder name
# @return: 0 if the folder name is valid, 1 otherwise
is_valid_folder_name() {
    local folder_name=$1

    # Remove all spaces from the folder name
    folder_name=$(echo "$folder_name" | tr -d ' ')

    # Check for empty input
    if [[ -z "$folder_name" ]]; then
        printf "!!! The folder name cannot be empty. " >&2
        return 1
    fi

    # Check for length
    if [[ ${#folder_name} -gt 100 ]]; then
        printf "!!! The folder name is too long (max 255 characters). " >&2
        return 1
    fi

    # Check for invalid characters
    if [[ "$folder_name" =~ [/\\\:\*\?\"\<\>\|] ]]; then
        printf "!!! The folder name contains invalid characters (\\ / : * ? \" < > |). " >&2
        return 1
    fi

    # Check if the folder already exists
    if [[ -d "$directory/${folder_name}" ]]; then
        printf "!!! The folder already exists. " >&2
        return 1
    fi

    return 0
}

# Get the folder path from the user and store it in the folder_path variable
get_folder_path() {
    local count=0
    
    printf "Use the current directory ($(pwd))? (y/n): "
    read -r user_input
    
    if [[ "$user_input" == "y" ]]; then
        folder_path=$(pwd)
        return
    fi

    while [[ count -lt 5 ]]; do
        printf "Enter path: "
        read -r user_input

        # input validation
        if [[ ! -d "$user_input" ]]; then
            if [[ -z "$user_input" ]]; then
                # >&2 redirects the output to stderr
                printf "!!! the directory cannot be empty, try again.\n" >&2
            elif [[ -f "$user_input" ]]; then
                printf "!!! the directory cannot be a file, try again.\n" >&2
            else
                printf "!!! the directory does not exist, try again.\n" >&2
            fi
            count=$((count + 1))
            continue
        elif [[ ! -w "$user_input" ]]; then
            printf "!!! you don't have write permissions for the directory, try again.\n" >&2
            count=$((count + 1))
            continue
        fi

        # Set the folder path
        folder_path="$user_input"
        break
    done

    # user failed to provide a valid directory 5 times
    if [[ -z "$folder_path" ]]; then
        printf "!!! no directory selected, exiting.\n" >&2
        exit 1
    fi
}

# Get the mode
get_mode() {
    local count=0

    while [[ count -lt 5 ]]; do
        printf "Choose a mode (1: Regular (r), 2: Single (s)): "
        read -r user_input

        # input validation
        if [[ "$user_input" != "r" && "$user_input" != "s" ]]; then
            printf "!!! invalid mode, try again.\n" >&2
            count=$((count + 1))
        else
            mode="$user_input"
            break
        fi
    done
}

ask_folder_confirmation() {
    printf "The following folders will be created:\n"
    for name in "${names_list[@]}"; do
        printf "%s\n" "$name"
    done

    printf "Do you want to continue and create the folders? (y/n): "
    read -r user_input

    if [[ "$user_input" != "y" && "$user_input" != "Y" ]]; then
        printf "Creating folders aborted. Exiting program.\n"
        exit 0
    fi

    return 0 # 0 in shell scripts means success, which translates to 'true' for other languages
}

# Create folders from a list of names
create_folders() {
    printf "Creating folders...\n"
    for name in "${names_list[@]}"; do
        mkdir "$folder_path/$name"
    done
}

# List the folders created
list_folders() {
    cd "$folder_path" || exit 1
    ls
}

# Create multiple folders in regular mode
regular_mode() {
    name_stem=""
    number_of_digits=0

    # Get the stem of the names
    local count=0
    while [[ count -lt 5 ]]; do
        printf "Name stem: "
        read -r name_stem

        if is_valid_folder_name "$name_stem"; then
            break
        else
            count=$((count + 1))
        fi
    done

    if [[ count -eq 5 && "$name_stem" == "" ]]; then
        printf "!!! You failed to enter a valid name stem. Exiting program.\n" >&2
        exit 1
    fi

    # Get the number of digits in the number of folders
    count=0
    while [[ count -lt 5 ]]; do
        printf "Number of digits: "
        read -r number_of_digits

        if [[ 0 -lt "$number_of_digits" && "$number_of_digits" -lt 10 ]]; then
            break
        else
            printf "!!! The number of digits must be a positive integer lower than 10." >&2
            count=$((count + 1))
        fi
    done

    if [[ count -eq 5 ]]; then
        printf "!!! You failed to enter a valid number of digits. Exiting program.\n" >&2
        exit 1
    fi
    
    # Get the range of the numbers
    count=0
    start=0
    end=0
    while [[ count -lt 5 ]]; do
        printf "Range (start end): "
        read -r start end

        if [[ "$start" == "" || "$end" == "" ]]; then
            printf "!!! The range cannot be empty. " >&2
            count=$((count + 1))
            continue
        fi

        if [[ ! "$start" =~ ^[0-9]+$ || ! "$end" =~ ^[0-9]+$ ]]; then
            printf "!!! The range must be composed of integers. " >&2
            count=$((count + 1))
            continue
        fi

        if [[ "$start" -lt 0 || "$end" -lt 0 ]]; then
            printf "!!! The range (start and end) must be positive. " >&2
            count=$((count + 1))
            continue
        fi

        if [[ "$start" -lt "$end" ]]; then
            break
        else
            printf "!!! The start number must be smaller than the end number. " >&2
            count=$((count + 1))
        fi
    done

    if [[ count -eq 5 ]]; then
        printf "!!! You failed at providing a valid range. Exiting program.\n" >&2
        exit 1
    fi

    # Create the folder list
    for ((i = start; i <= end; i++)); do
        # Create the folder name with the correct number of digits (padded with zeros)
        folder_name="${name_stem}$(printf "%0${number_of_digits}d" "$i")"
        names_list+=("$folder_name")
    done

    if ask_folder_confirmation; then
        create_folders
    else
        printf "Creating folders aborted. Exiting program.\n"
        exit 0
    fi
}

# Create multiple folders in single mode
single_mode() {
    printf "Enter the folder names. Enter '-q' when done.\n"
    while true; do
        printf "Next folder name: "
        read -r folder_name

        if [[ "$folder_name" == "-q" ]]; then
            break
        fi

        if is_valid_folder_name "$folder_name"; then
            names_list+=("$folder_name")
        fi
    done

    if ask_folder_confirmation; then
        create_folders
    else
        printf "Creating folders aborted. Exiting program.\n"
        exit 0
    fi
}

# ==============================================================================
# Main
# ==============================================================================

# Variables
folder_path="" # Path to the folder where the folders will be created
mode="" # Mode (r: Regular, s: Single)
names_list=() # List of names for the folders

get_folder_path
get_mode

if [[ $mode == "r" ]]; then
    regular_mode
elif [[ $mode == "s" ]]; then
    single_mode
else
    printf "!!! Invalid mode. Exiting program.\n" >&2
    exit 1
fi

printf "--> Done!\n"
printf "Folders created:\n"
list_folders

