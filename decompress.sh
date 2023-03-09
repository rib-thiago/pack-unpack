#!/usr/bin/env bash

################################################################################
#                                                                              #
#                             decompress.sh                                    #
#                                                                              #
################################################################################

# Description:
# This is a bash script that allows you to extract and view files from various
# compressed formats such as gzip, bzip2, zip, rar, and tar.
#
# Author: Thiago Ribeiro
# Date: 2023-01-07
# Version: 0.0.1
#
# Usage:
# To use the script, run it with the following options:
#  -x: extract contents to the current folder
#  -l: view contents of the archive file
#  -h: display the help message
#
# Example usage:
#  archive.sh -x compressed_file.tar.g

# To use the script, simply run it with one or more file names as arguments.
# If no argumnents are specified, the script will display an error message and exit.
# When you run the compress.sh script, it will prompt you to choose a
# compression tool from a menu: Once a compression tool is selected, the script
# will compress the files in the background using the selected tool and display
# a progress bar. Once the compression is completed, a successful completion
# message will be displayed along with the name of the output file.
#
# Dependencies:
#
# - tar
# - guzip
# - buzip2
# - unxz
# - unzip
# - unrar

#
# Notes:
# None.
#
# --------------- #
# Change Log       #
# --------------- #
#
# Version   Date          Author          Description
# -------   ----          ------          -----------
# 0.0.1     [2023-01-07]  Thiago Ribeiro  Initial release.
#
#

# TODO:
#  Alterar o modo de uso no cabeçalho
#  Fazer um README.md
#  Escrever mensagens de uso
#
#
# FIXME:
# None.
#
# XXX:
# None.
#
################################################################################

# Check if any arguments were passed on the command line
if [ $# -eq 0 ]; then
    echo "Error: No arguments specified"
    exit 1
fi

# Set the command based on the command line options
while getopts ":xlh" opt; do
    case $opt in
    x) cmd="extract" ;;
    l) cmd="view" ;;
    h)
        echo "Usage: $0 [options] file"
        echo " Options:"
        echo "    -x  extract contents to current folder"
        echo "    -l  view contents of archive file"
        echo "    -h  show this help message"
        exit 0
        ;;
    ?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    esac
done
shift $((OPTIND - 1))

# If no options were passed, display the menu
if [ -z "$cmd" ]; then
    echo "What would you like to do with the packaged file?"
    echo "1) Extract contents to current folder"
    echo "2) View contents of archive file"
    read -rp "Enter the number of your choice: " choice

    # Set the command based on the choice
    case $choice in
    1) cmd="extract" ;;
    2) cmd="view" ;;
    *)
        echo "Error: Invalid choice"
        exit 1
        ;;
    esac
fi

# Set the input file
input_file="$1"

# Test the file to find out what the compression format is
if file "$input_file" | grep -q "gzip compressed data"; then
    compression="gzip"
    extract="tar -xzf"
    view="gunzip -c"
elif file "$input_file" | grep -q "bzip2 compressed data"; then
    compression="bzip2"
    extract="tar -xjf"
    view="bunzip2 -c"
elif file "$input_file" | grep -q "Zip archive data"; then
    compression="zip"
    extract="unzip -q"
    view="unzip -l"
elif file "$input_file" | grep -q "RAR archive data"; then
    compression="rar"
    extract="unrar x -o"
    view="unrar l"
elif file "$input_file" | grep -q "POSIX tar archive (GNU)"; then
    compression="tar"
    extract="tar -xvf"
    view="tar -tvf"
fi

[ $cmd = "extract" ] && $extract "$input_file" >/dev/null 2>&1 &

[ $cmd = "view" ] && $view "$input_file"

# Display a progress bar while the compression is running
pid=$!
while kill -0 "$pid" 2>/dev/null; do
    printf "+"
    sleep 1
done
