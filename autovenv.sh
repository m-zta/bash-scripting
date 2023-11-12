#!/bin/bash

# TODO:
# - Prevent user from entering a directory outside of the home directory
# - Add option to create a git repository

# ---------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------

DEFAULT_PARENT_DIR="/Users/mario/code/python"

# ---------------------------------------------------------------------
# Functions
# ---------------------------------------------------------------------

# Install tools in virtual environment
install_tools() {
    source "$1/bin/activate" # This warning is just because the directory exists only at runtime
    pip install --upgrade pip
    pip install autopep8
    deactivate
}

# Create virtual environment and install tools
create_venv() {
    venvname="venv"
    currentdir=$(pwd)
    cd "$parentdir/$projectname" || (printf "Failed to cd to %s/%s" "$parentdir" "$projectname" && exit 1)
    python3 -m venv "$venvname"
    install_tools "$venvname"
    cd "$currentdir" || exit 1
}

# Create project directory
create_project_directory() {
    if ! mkdir "$parentdir/$1"; then
        printf "Failed to create project directory %s/%s" "$parentdir" "$projectname"
        exit 1
    else
        printf "Created project directory %s/%s" "$parentdir" "$projectname"
    fi
}

get_parent_directory() {
    printf "Where do you want to create the project? \n"
    printf "c - current directory \nd - default directory (~/code/python) \ne - enter other directory \n"

    while true; do
        read -r use_default

        case $use_default in
        [Cc]*)
            parentdir=$(pwd)
            break
            ;;
        [Dd]*)
            parentdir="$DEFAULT_PARENT_DIR"
            break
            ;;
        [Ee]*)
            printf "Enter project directory: "
            read -r parentdir
            if [[ ! -d "$parentdir" ]]; then
                printf "Directory %s does not exist. Try again\n" "$parentdir"
                continue
            else
                break
            fi
            ;;
        *)
            printf "Please answer c, d or e: " <&2
            ;;
        esac
    done
}

create_git_repository() {
    printf "Want to create a git repository? (y/n) "
    read -r answer

    if [[ $answer == [Yy]* ]]; then
        cd "$parentdir/$projectname" || exit 1
        git init
        touch .gitignore
        echo "venv" >>.gitignore
        echo ".DS_Store" >>.gitignore
        echo ".vscode" >>.gitignore
        touch README.md
        git add .
        git commit -m "Initial commit"
    fi
}

# ---------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------

# Get parent directory
parentdir=""
get_parent_directory

# Get project name and create project directory
printf "You are about to create a new python project in %s \nEnter a project name: " "$parentdir"
read -r projectname
create_project_directory "$projectname"

create_venv

create_git_repository

printf "\nDone!\n"
