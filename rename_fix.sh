#!/bin/bash

# Function to display a prompt and read user input
read_input() {
    read -p "$1" input
    echo "$input"
}

# Main script
echo "Welcome to 'remove_fix'! This program removes a prefix or a suffix from filenames in a directory recursively, preserving the file extension."

# Step 1: Prompt for prefix or suffix
mode=$(read_input "Do you want to remove a prefix or a suffix? (Enter 'prefix' or 'suffix'): ")

# Validate input
if [[ "$mode" != "prefix" && "$mode" != "suffix" ]]; then
    echo "Error: Invalid option. Please enter 'prefix' or 'suffix'."
    exit 1
fi

# Step 2: Prompt for the directory
directory=$(read_input "Enter the directory path: ")

# Validate the directory
if [ ! -d "$directory" ]; then
    echo "Error: Directory does not exist."
    exit 1
fi

# Step 3: Prompt for the string to remove (prefix or suffix)
if [[ "$mode" == "prefix" ]]; then
    fix=$(read_input "Enter the prefix to remove: ")
else
    fix=$(read_input "Enter the suffix to remove: ")
fi

# Step 4: Find matching files recursively
files=$(find "$directory" -type f)

# Filter files based on mode
matching_files=()
for file in $files; do
    base_name=$(basename "$file")
    extension="${base_name##*.}"
    name_without_extension="${base_name%.*}"

    if [[ "$mode" == "prefix" && "$name_without_extension" == "$fix"* ]]; then
        matching_files+=("$file")
    elif [[ "$mode" == "suffix" && "$name_without_extension" == *"$fix" ]]; then
        matching_files+=("$file")
    fi
done

file_count=${#matching_files[@]}

if [ "$file_count" -eq 0 ]; then
    echo "No files with the specified $mode found in the directory."
    exit 0
fi

# Display the count
echo "Found $file_count file(s) with the specified $mode '$fix'."

# Step 5: Ask for confirmation
read -p "Do you want to rename these files? (y/n): " confirmation
if [[ "$confirmation" != "y" && "$confirmation" != "Y" ]]; then
    echo "Operation cancelled."
    exit 0
fi

# Step 6: Rename the files
for file in "${matching_files[@]}"; do
    if [ -e "$file" ]; then
        dir_name=$(dirname "$file")
        base_name=$(basename "$file")
        extension="${base_name##*.}"
        name_without_extension="${base_name%.*}"

        if [[ "$mode" == "prefix" ]]; then
            new_name="${name_without_extension#$fix}.$extension"
        else
            new_name="${name_without_extension%$fix}.$extension"
        fi

        mv "$file" "$dir_name/$new_name"
        echo "Renamed: '$file' -> '$dir_name/$new_name'"
    fi
done

echo "Renaming completed."

