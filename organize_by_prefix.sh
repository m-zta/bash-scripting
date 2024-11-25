#!/bin/bash

# Function to display a prompt and read user input
read_input() {
    read -p "$1" input
    echo "$input"
}

# Main script
echo "This script organizes files by their prefix in a directory."

# Step 1: Prompt for the directory
directory=$(read_input "Enter the directory path: ")

# Validate the directory
if [ ! -d "$directory" ]; then
    echo "Error: Directory does not exist."
    exit 1
fi

# Step 2: Prompt for the prefix depth
prefix_depth=$(read_input "Enter the prefix length: ")

# Validate the prefix depth
if ! [[ "$prefix_depth" =~ ^[0-9]+$ ]]; then
    echo "Error: Prefix length must be a number."
    exit 1
fi

# Step 3: Find unique prefixes of the given length
prefixes=$(find "$directory" -type f | while read -r file; do
    basename "$file" | cut -c 1-"$prefix_depth"
done | sort | uniq)

# Step 4: Create folders and move files
for prefix in $prefixes; do
    # Skip empty prefixes
    if [ -z "$prefix" ]; then
        continue
    fi

    # Create a folder for the prefix
    folder_path="$directory/$prefix"
    mkdir -p "$folder_path"

    # Move files with the prefix into the folder
    for file in "$directory"/"$prefix"*; do
        if [ -e "$file" ]; then
            mv "$file" "$folder_path/"
            echo "Moved: '$file' -> '$folder_path/'"
        fi
    done
done

echo "Organization by prefix completed."

