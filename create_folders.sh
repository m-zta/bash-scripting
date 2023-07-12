#!/bin/bash

# ----------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------

# Function to set the directory from user input
# Input: none
# Output: sets the "directory" variable
set_directory() {
    while true; do
        echo "Directory: "
        read -r input

        if [[ -d "$input" ]]; then
            directory="$input"
            break
        else
            echo "The directory does not exist, try again."
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

    mkdir "$dir/${new_folder}"
}

create_folders() {
    echo "Enter the name of the new folders you want to create (enter '-q' to exit):"

    while true; do
        echo "Name: "
        read -r folder_name

        if [[ "$folder_name" == "-q" ]]; then
            echo "Exiting."
            break
        else
            create_directory "$directory" "$folder_name"
        fi
    done

    # list the directories
    list_directories "$directory"
}

# Function to list the new directories
# Input: "directory" name
# Output: lists the new directories and their contents
list_directories() {
    local dir=$1
    echo "Directories in ${dir}:"
    ls "${dir}"/*/ # */ is a wildcard that matches all directories
}

# ----------------------------------------------------------------------
# Main script
# ----------------------------------------------------------------------

# Ask for the path to the directory and set it
echo "Enter the path to the directory where you want to create the new folders:"
directory=""
set_directory

# Create the new folders
create_folders
