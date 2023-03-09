#!/usr/bin/env bash

################################################################################
#                                                                              #
#                               compress.sh                                    #
#                                                                              #
################################################################################

# Description:
# This is a bash script that allows you to compress files using various
# compression tools, such as tar, zip, and rar.
#
# Author: Thiago Ribeiro
# Date: 2023-01-07
# Version: 0.0.1
#
# Usage:
# To use the script, simply run it with one or more file names as arguments.
# If no files are specified, the script will display an error message and exit.
# When you run the compress.sh script, it will prompt you to choose a
# compression tool from a menu: Once a compression tool is selected, the script
# will compress the files in the background using the selected tool and display
# a progress bar. Once the compression is completed, a successful completion
# message will be displayed along with the name of the output file.
#
# Dependencies:
#  MISSING_DEPENDENCIES+=("tar")
# - gzip
# - bzip2
# - xz-utils
# - zip
# - rar

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
# 0.0.2     [2023-01-07]  Thiago Ribeiro  Suporte ao getopts
#

# TODO:
#  Alterar o modo de uso no cabeçalho
#  Fazer um README.md
#  Escrever mensagens de uso
#  Cirar script decompress
#
# FIXME:
# None.
#
# XXX:
# None.
#
################################################################################

# Check if any files were passed as arguments
if [ $# -eq 0 ]; then
    echo "Error: No files specified"
    exit 1
fi

# Set the compression command and extension based on the command line options
while getopts ":tgbzrh" opt; do
    case $opt in
    t)
        cmd="tar cf"
        ext=".tar"
        ;;
    g)
        cmd="tar zcf"
        ext=".tar.gz"
        ;;
    b)
        cmd="tar jcf"
        ext=".tar.bz2"
        ;;
    z)
        cmd="zip -q -r"
        ext=".zip"
        ;;
    r)
        cmd="rar a -r -s -m5 -ep1"
        ext=".rar"
        ;;
    h)
        echo "Usage: $0 [options] file1 file2 file3 ..."
        echo "  Options:"
        echo "    -t  tar"
        echo "    -g  tar.gz"
        echo "    -b  tar.bz2"
        echo "    -z  zip"
        echo "    -r  rar"
        echo "    -h  show this help message"
        exit 0
        ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    esac
done
shift $((OPTIND - 1))

# If no options were passed, display the menu
if [ -z "$cmd" ]; then
    echo "Choose a compression tool:"
    echo "1) tar"
    echo "2) tar.gz"
    echo "3) tar.bz2"
    echo "4) zip"
    echo "5) rar"
    read -p "Enter the number of your choice: " choice

    # Set the compression command and extension based on the choice
    case $choice in
    1)
        cmd="tar cf"
        ext=".tar"
        ;;
    2)
        cmd="tar zcf"
        ext=".tar.gz"
        ;;
    3)
        cmd="tar jcf"
        ext=".tar.bz2"
        ;;
    4)
        cmd="zip -q -r"
        ext=".zip"
        ;;
    5)
        cmd="rar a -r -s -m5 -ep1"
        ext=".rar"
        ;;
    *)
        echo "Error: Invalid choice"
        exit 1
        ;;
    esac
fi

# Set the output file name
output_file="${PWD##*/}$ext"

# Perform the compression in silent mode
$cmd "$output_file" "$@" >/dev/null 2>&1 &

# Display a progress bar while the compression is running
pid=$!
while kill -0 "$pid" 2>/dev/null; do
    printf "+"
    sleep 1
done

# Display a successful completion message
echo -e "\nCompression completed successfully"
echo "Output file: $output_file"
