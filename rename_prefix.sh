#!/bin/bash

# Function to display a prompt and read user input
read_input() {
    read -p "$1" input
    echo "$input"
}

# Main script
echo "This script renames all files with a specific prefix in a directory."

# Step 1: Prompt for the directory
directory=$(read_input "Enter the directory path: ")

# Validate the directory
if [ ! -d "$directory" ]; then
    echo "Error: Directory does not exist."
    exit 1
fi

# Step 2: Prompt for the prefix
prefix=$(read_input "Enter the prefix to search for: ")

# Count files with the prefix
file_count=$(find "$directory" -type f -name "${prefix}*" | wc -l)

if [ "$file_count" -eq 0 ]; then
    echo "No files with the prefix '$prefix' found in the directory."
    exit 0
fi

# Display the count
echo "Found $file_count file(s) with the prefix '$prefix'."

# Step 3: Ask for confirmation
read -p "Do you want to rename these files? (y/n): " confirmation
if [[ "$confirmation" != "y" && "$confirmation" != "Y" ]]; then
    echo "Operation cancelled."
    exit 0
fi

# Step 4: Rename the files
for file in "$directory"/"${prefix}"*; do
    if [ -e "$file" ]; then
        base_name=$(basename "$file")
        new_name="${base_name#$prefix}"
        mv "$file" "$directory/$new_name"
        echo "Renamed: '$file' -> '$directory/$new_name'"
    fi
done

echo "Renaming completed."

