#!/bin/bash

# Check if exactly one argument is provided
if [ $# -ne 1 ]; then
    echo "Error: Exactly one argument required."
    echo "Usage: $0 <file_or_directory>"
    exit 1
fi

path="$1"

# Check if the path exists
if [ ! -e "$path" ]; then
    echo "Error: '$path' does not exist."
    exit 1
fi

# If it's a file
if [ -f "$path" ]; then
    echo "Analyzing file: $path"
    lines=$(wc -l < "$path")
    words=$(wc -w < "$path")
    chars=$(wc -m < "$path")
    echo "Lines: $lines"
    echo "Words: $words"
    echo "Characters: $chars"

# If it's a directory
elif [ -d "$path" ]; then
    echo "Analyzing directory: $path"
    total_files=$(find "$path" -maxdepth 1 -type f | wc -l)
    txt_files=$(find "$path" -maxdepth 1 -type f -name "*.txt" | wc -l)
    echo "Total files: $total_files"
    echo "Number of .txt files: $txt_files"

# If it's neither file nor directory (e.g., symbolic link, device file)
else
    echo "Error: '$path' is neither a regular file nor a directory."
    exit 1
fi

exit 0

