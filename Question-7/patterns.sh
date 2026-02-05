#!/bin/bash

# Check if file is provided
if [ $# -ne 1 ]; then
    echo "Error: Text file name required."
    echo "Usage: $0 <filename>"
    exit 1
fi

input_file="$1"

# Check if file exists and is readable
if [ ! -f "$input_file" ]; then
    echo "Error: File '$input_file' does not exist."
    exit 1
fi

if [ ! -r "$input_file" ]; then
    echo "Error: File '$input_file' is not readable."
    exit 1
fi

# Clear output files
> vowels.txt
> consonants.txt
> mixed.txt

# Process each word (case-insensitive)
tr -s '[:space:]' '\n' < "$input_file" | tr -d '[:punct:]' | sed '/^$/d' | while read word; do
    # Convert to lowercase for pattern matching
    lower_word=$(echo "$word" | tr '[:upper:]' '[:lower:]')
    
    # Remove vowels - if nothing left, word contains ONLY vowels
    no_vowels=$(echo "$lower_word" | tr -d 'aeiou')
    if [ -z "$no_vowels" ]; then
        echo "$word" >> vowels.txt
        continue
    fi
    
    # Remove consonants - if nothing left, word contains ONLY consonants
    no_cons=$(echo "$lower_word" | tr -d 'bcdfghjklmnpqrstvwxyz')
    if [ -z "$no_cons" ]; then
        echo "$word" >> consonants.txt
        continue
    fi
    
    # Check if starts with consonant (case-insensitive)
    first_char=$(echo "$lower_word" | cut -c1)
    if [[ ! "$first_char" =~ [aeiou] ]]; then
        echo "$word" >> mixed.txt
    fi
done

# Display summary
echo "=== Pattern Analysis Complete ==="
echo "Words with only vowels: $(wc -l < vowels.txt)"
echo "Words with only consonants: $(wc -l < consonants.txt)"
echo "Words starting with consonant (mixed): $(wc -l < mixed.txt)"
echo "Output files: vowels.txt, consonants.txt, mixed.txt"
