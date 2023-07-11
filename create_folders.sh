#!/bin/bash

# Function to create a directory
create_directory() {
    local dir=$1
    local new_folder=$2
    mkdir "$dir/${new_folder}"
}

# Function to list the new directories
list_directories() {
    local dir=$1
    echo "Directories in ${dir}:"
    ls "${dir}"/*/
}

# Ask for the path to the directory
echo "Enter the path to the directory where you want to create the new folders:"
read directory

# Ask for folder names until "quit" is entered
while true; do
    echo "Enter a name for a new folder (or 'quit' to exit):"
    read folder_name

    if [[ "$folder_name" == "quit" ]]; then
        echo "Exiting."
        break
    else
        create_directory "$directory" "$folder_name"
    fi
done

# list the directories
list_directories "$directory"
