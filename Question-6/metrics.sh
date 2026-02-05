#!/bin/bash

# Check if input.txt exists
if [ ! -f "input.txt" ]; then
    echo "Error: input.txt not found in current directory."
    exit 1
fi

# Check if file is not empty
if [ ! -s "input.txt" ]; then
    echo "Error: input.txt is empty."
    exit 1
fi

# Process file: convert to one word per line, remove punctuation, ignore case for uniqueness
WORDS=$(tr -s '[:space:]' '\n' < input.txt | tr -d '[:punct:]' | sed '/^$/d')

# If no valid words remain
if [ -z "$WORDS" ]; then
    echo "Error: No valid words found in input.txt."
    exit 1
fi

# Total word count
TOTAL_WORDS=$(echo "$WORDS" | wc -l)

# Find longest word
LONGEST=$(echo "$WORDS" | awk '{ print length, $0 }' | sort -nr | head -1 | awk '{print $2}')
LONGEST_LEN=$(echo -n "$LONGEST" | wc -c)

# Find shortest word
SHORTEST=$(echo "$WORDS" | awk '{ print length, $0 }' | sort -n | grep -v "^0" | head -1 | awk '{print $2}')
SHORTEST_LEN=$(echo -n "$SHORTEST" | wc -c)

# Calculate average word length
TOTAL_CHARS=$(echo "$WORDS" | tr -d '\n' | wc -c)
AVG_LEN=$(echo "scale=2; $TOTAL_CHARS / $TOTAL_WORDS" | bc)

# Count unique words (case insensitive)
UNIQUE_WORDS=$(echo "$WORDS" | tr '[:upper:]' '[:lower:]' | sort | uniq | wc -l)

# Display results
echo "=== Text File Analysis (input.txt) ==="
echo "Longest word: '$LONGEST' ($LONGEST_LEN characters)"
echo "Shortest word: '$SHORTEST' ($SHORTEST_LEN characters)"
echo "Average word length: $AVG_LEN characters"
echo "Total unique words: $UNIQUE_WORDS"
