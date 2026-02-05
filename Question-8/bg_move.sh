#!/bin/bash

# Check if directory argument is provided
if [ $# -ne 1 ]; then
    echo "Error: Directory path required."
    echo "Usage: $0 <directory_path>"
    exit 1
fi

dir_path="$1"

# Validate directory exists
if [ ! -d "$dir_path" ]; then
    echo "Error: Directory '$dir_path' does not exist."
    exit 1
fi

# Create backup subdirectory if it doesn't exist
backup_dir="$dir_path/backup"
mkdir -p "$backup_dir"

echo "Starting background file move from '$dir_path' to '$backup_dir/'"
echo "Parent process PID: $$"
echo ""

# Array to store background PIDs
pids=()

# Move each file (non-directory) in the background
for file in "$dir_path"/*; do
    # Skip if no files match the pattern
    [ -e "$file" ] || continue
    
    # Skip if it's a directory (including backup itself)
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        # Move file in background
        mv "$file" "$backup_dir/" &
        
        # Capture PID of the background process
        pid=$!
        pids+=($pid)
        
        echo "Moved '$filename' in background (PID: $pid)"
    fi
done

echo ""
echo "All background moves launched. Waiting for completion..."

# Wait for all background processes to finish
for pid in "${pids[@]}"; do
    wait "$pid"
done

echo "All background file moves completed."
echo "Files moved to: $backup_dir/"
