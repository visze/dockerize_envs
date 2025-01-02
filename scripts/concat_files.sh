# -----------------------------------------------------------------------------
# 
# DESCRIPTION: This script concatenates multiple files into a single file.
# 
# USAGE: ./concat_files.sh [yes|no] input_file1 [input_file2 ... input_fileN]
# 
# AUTHOR: Max Schubach
# DATE: 2023-10-05
# LICENSE: MIT License
# -----------------------------------------------------------------------------
#!/bin/bash

# Check if at least two arguments are provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 has_header input_file1 [input_file2 ... input_fileN]"
    exit 1
fi

# Get the header option
has_header=$1
shift 1

# Check if the header option is valid
if [ "$has_header" != "yes" ] && [ "$has_header" != "no" ]; then
    echo "The first argument must be 'yes' or 'no' to indicate if files have headers"
    exit 1
fi

# Function to check if a file is gzip compressed
is_gzip() {
    file "$1" | egrep -q 'gzip compressed data|Blocked GNU Zip Format'
}

# Concatenate files
if [ "$has_header" == "yes" ]; then
    # Take the header from the first file and print it
    if is_gzip "$1"; then
        zcat "$1" | awk 'NR==1{print; exit}'
    else
        awk 'NR==1{print; exit}' "$1"
    fi
    # Concatenate the rest of the files, skipping the header in each
    for file in "$@"; do
        if is_gzip "$file"; then
            zcat "$file" | awk 'NR>1'
        else
            awk 'NR>1' "$file"
        fi
    done
else
    # Concatenate all files without skipping any lines
    for file in "$@"; do
        if is_gzip "$file"; then
            zcat "$file"
        else
            cat "$file"
        fi
    done
fi
