#!/bin/bash

# Description: Create new folders in a given directory
# Usage: create_folders.sh

# TODO:
# - Add a function to delete the new folders
# - Add a function to rename the new folders
# - Logging (to a file)
# - Check for required tools (e.g. mkdir, ls, etc.)
# - Improve UI
# - Consider using different return values for different errors

# ----------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------

# Function to set the directory from user input
# Input: none
# Output: sets the "directory" variable
set_directory() {
    while true; do
        printf "Directory: "
        read -r input

        if [[ ! -d "$input" ]]; then
            if [[ -z "$input" ]]; then
                # >&2 redirects the output to stderr
                printf "!!! The directory cannot be empty, try again.\n" >&2
            elif [[ -f "$input" ]]; then
                printf "!!! The directory cannot be a file, try again.\n" >&2
            else
                printf "!!! The directory does not exist, try again.\n" >&2
            fi
        elif [[ ! -w "$input" ]]; then
            printf "!!! You don't have write permissions for the directory, try again.\n" >&2
        else
            directory="$input"
            break
        fi
    done
}

# Function to check user input for the new folder name
# Input: "new_folder" name
# Output: returns 0 if the name is valid, 1 otherwise
valid_folder_name() {
    # use local to avoid overwriting global variables
    local folder_name=$2

    # Remove leading and trailing whitespace
    folder_name=$(echo "$folder_name" | tr -d ' ')

    # Check for empty input
    if [[ -z "$folder_name" ]]; then
        printf "!!! The folder name cannot be empty. " >&2
        return 1
    fi

    # Check for too long input
    if [[ ${#folder_name} -gt 255 ]]; then
        printf "!!! The folder name is too long (max 255 characters). " >&2
        return 1
    fi

    # Check for invalid characters
    if [[ "$folder_name" =~ [/\\:\*\?\"\<\>\|] ]]; then
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

# Function to create the new folder 
# Input: "directory" and "new_folder" names
# Output: creates the directory and adds its name to the array
add_folder() {
    # use local to avoid overwriting global variables
    local dir=$1 # $1 is the first argument passed to the function
    local new_folder=$2

    # Check if the folder name is valid
    if ! valid_folder_name "$dir" "$new_folder"; then
        printf "Try again.\n" >&2
        return 1
    fi

    # Try to add the folder
    if mkdir "$dir/${new_folder}"; then
        # If the directory was successfully created, add its name to the array
        new_dirs+=("$new_folder")
    else
        printf "!!! There was a problem creating the folder. " >&2
        return 1
    fi

    return 0
}

# Function to list the new directories
# Input: "directory" name
# Output: lists the new directories and their contents
list_directories() {
    printf "New folders created:\n"

    # Loop through the array and print the new directories
    for dir in "${new_dirs[@]}"; do
        printf "> %s\n" "$dir"
    done
}

# Input: None
# Output: Creates the new folders and lists them
create_folders() {
    printf "Enter the name of the new folders you want to create (enter '-q' to exit):\n"
    new_dirs=()

    while true; do
        printf "name: "
        read -r folder_name

        if [[ "$folder_name" == "-q" ]]; then
            printf "Done.\n\n"
            break
        elif ! add_folder "$directory" "$folder_name"; then
            # Remark: In bash, a function returns 0 if it succeeds and 1 if it fails.
            # The block is executed if add_folder returns 1.
            printf "Try again.\n" >&2
        fi
    done

    # list the directories
    list_directories
}

# Input: None
# Output: Sets the "mode" variable according to user input
set_mode() {
    count=0
    
    # Try to get the mode from the user input 5 times
    while count -lt 5; do
        printf "Mode ('test' or 'run'): "
        read -r user_input

        if [[ "$user_input" == "test" || "$user_input" == "run" ]]; then
            mode="$user_input"
            break
        else
            printf "!!! Invalid mode input, try again.\n" >&2
        fi
    done

    # If the user input was invalid 5 times, exit the script
    if [[ -z "$mode" ]]; then
        printf "!!! No mode selected, exiting.\n" >&2
        exit 1
    fi
}

# ----------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------

directory=""
mode=""

set_mode

if [[ "$mode" == "test" ]]; then
    directory="/Users/mario/test"
elif [[ "$mode" == "run" ]]; then
    # Ask for the path to the directory and set it
    printf "Enter the path to the directory where you want to create the new folders:\n"
    set_directory
fi

# Create the new folders
create_folders
