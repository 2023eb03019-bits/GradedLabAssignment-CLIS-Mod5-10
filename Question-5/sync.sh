#!/bin/bash

# Check if both directories are provided
if [ $# -ne 2 ]; then
    echo "Error: Two directory names required."
    echo "Usage: $0 <dirA> <dirB>"
    exit 1
fi

dirA="$1"
dirB="$2"

# Validate directories exist
if [ ! -d "$dirA" ]; then
    echo "Error: Directory '$dirA' does not exist."
    exit 1
fi

if [ ! -d "$dirB" ]; then
    echo "Error: Directory '$dirB' does not exist."
    exit 1
fi

echo "=== Comparing directories: $dirA vs $dirB ==="
echo ""

# Files only in dirA
echo "1. Files present ONLY in $dirA:"
comm -23 <(ls "$dirA" | sort) <(ls "$dirB" | sort) | sed 's/^/   /'
echo ""

# Files only in dirB
echo "2. Files present ONLY in $dirB:"
comm -13 <(ls "$dirA" | sort) <(ls "$dirB" | sort) | sed 's/^/   /'
echo ""

# Files common to both
echo "3. Files common to both directories (comparing content):"
common_files=$(comm -12 <(ls "$dirA" | sort) <(ls "$dirB" | sort))

if [ -z "$common_files" ]; then
    echo "   No common files found."
else
    match_count=0
    diff_count=0
    
    for file in $common_files; do
        if cmp -s "$dirA/$file" "$dirB/$file"; then
            echo "   $file: CONTENT MATCH"
            match_count=$((match_count + 1))
        else
            echo "   $file: CONTENT DIFFERENT"
            diff_count=$((diff_count + 1))
        fi
    done
    
    echo ""
    echo "   Summary: $match_count files identical, $diff_count files differ."
fi
