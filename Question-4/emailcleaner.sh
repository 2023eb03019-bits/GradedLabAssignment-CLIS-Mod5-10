#!/bin/bash

# Check if emails.txt exists
if [ ! -f "emails.txt" ]; then
    echo "Error: emails.txt not found in current directory."
    exit 1
fi

# Clear output files if they exist (or create empty)
> valid.txt
> invalid.txt

# Define valid email pattern: letters/digits + @ + letters + .com
# No spaces, no special characters except @ and dot in .com
VALID_PATTERN='^[a-zA-Z0-9]\+@[a-zA-Z]\+\.com$'

# Extract valid emails
grep -x "$VALID_PATTERN" emails.txt | sort -u > valid.txt

# Extract invalid emails (lines not matching pattern)
grep -v -x "$VALID_PATTERN" emails.txt > invalid.txt

# Display summary
valid_count=$(wc -l < valid.txt)
invalid_count=$(wc -l < invalid.txt)

echo "=== Email Cleaning Summary ==="
echo "Valid emails found: $valid_count (saved in valid.txt)"
echo "Invalid emails found: $invalid_count (saved in invalid.txt)"
echo "Duplicates removed from valid.txt automatically."
