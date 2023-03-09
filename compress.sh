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
# 

# TODO:
# Adicionar suporte ao getopts
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

# Display menu to choose compression tool
echo "Choose a compression tool:"
echo "1) tar"
echo "2) tar.gz"
echo "3) tar.bz2"
echo "4) zip"
echo "5) rar"
read -rp "Enter the number of your choice: " choice

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

# Display a successful completion message
echo -e "\nCompression completed successfully"
echo "Output file: $output_file"
