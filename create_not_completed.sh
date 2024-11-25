#!/bin/bash

# Function to display a prompt and read user input
read_input() {
    read -p "$1" input
    echo "$input"
}

# Main script
echo "This script creates a file named 'NOT_COMPLETED.txt' in each subdirectory of a given directory."

# Step 1: Prompt for the directory
directory=$(read_input "Enter the directory path: ")

# Validate the directory
if [ ! -d "$directory" ]; then
    echo "Error: Directory does not exist."
    exit 1
fi

# Step 2: Iterate over all subdirectories
find "$directory" -type d | while read -r subdirectory; do
    # Create the NOT_COMPLETED.txt file in the subdirectory
    touch "$subdirectory/NOT_COMPLETED.txt"
    echo "Created: '$subdirectory/NOT_COMPLETED.txt'"
done

echo "File creation completed."

