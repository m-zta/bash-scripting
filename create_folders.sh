#!/bin/bash

# TODO:
# - User input validation
# - Use function for reading and validating user input
# - Handle edge cases
# - Add a function to delete the new folders
# - Add a function to rename the new folders
# - Logging (to a file)
# - Check for required tools (e.g. mkdir, ls, etc.)
# - Improve UI

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

        if [[ -d "$input" ]]; then
            directory="$input"
            break
        else
            # >&2 redirects the output to stderr
            printf "!!! The directory does not exist, try again.\n" >&2
        fi
    done
}

# Function to create a directory
# Input: "directory" and "new_folder" names
# Output: creates a new folder in the directory
create_directory() {
    # use local to avoid overwriting global variables
    local dir=$1 # $1 is the first argument passed to the function
    local new_folder=$2

    # Check the exit status of the mkdir command
    if mkdir "$dir/${new_folder}"; then
        # If the directory was successfully created, add its name to the array
        new_dirs+=("$new_folder")
    else
        printf "There was a problem creating the folder\n."
        return 1
    fi
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

# Function to create the new folders
# Input: none
# Output: creates the new folders and lists them
create_folders() {
    printf "Enter the name of the new folders you want to create (enter '-q' to exit):\n"
    new_dirs=()

    while true; do
        printf "New Folder: "
        read -r folder_name

        if [[ "$folder_name" == "-q" ]]; then
            printf "Exiting.\n"
            break
        elif ! create_directory "$directory" "$folder_name"; then
            printf "!!! There was a problem with the folder name, try again.\n" >&2
        fi
    done

    # list the directories
    list_directories
}

# Function to set the mode
# Input: none
# Output: sets the "mode" variable
set_mode() {
    while true; do
        printf "Mode ('test' or 'run'): "
        read -r input

        if [[ "$input" == "test" || "$input" == "run" ]]; then
            mode="$input"
            break
        else
            printf "!!! Invalid mode, try again.\n" >&2
        fi
    done
}

# ----------------------------------------------------------------------
# Main script
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
