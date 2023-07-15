#!/bin/bash

# ---------------------------------------------------------------------
# Script to create a new python project directory
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
# Functions
# ---------------------------------------------------------------------

get_project_directory() {
    printf "Use default directory (/Users/mario/code/python)? [y/n]: "

    while true; do
        read -r use_default

        case $use_default in
            [Yy]* )
                projectdir="/Users/mario/code/python"
                break
                ;;
            [Nn]* )
                printf "Enter project directory: "
                read -r projectdir
                if [[ ! -d "$projectdir" ]]; then
                    printf "Directory %s does not exist. Try again" "$projectdir"
                    continue
                fi
                ;;
            * )
                printf "Please answer yes or no: " <&2
                ;;
        esac
    done
}

# ---------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------


projectdir=""
get_project_directory
