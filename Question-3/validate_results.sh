#!/bin/bash

# Check if marks.txt exists
if [ ! -f "marks.txt" ]; then
    echo "Error: marks.txt not found in current directory."
    exit 1
fi

# Initialize counters
failed_one_count=0
passed_all_count=0

echo "=== Students who failed in exactly ONE subject ==="
while IFS=',' read -r rollno name m1 m2 m3; do
    # Trim whitespace
    rollno=$(echo "$rollno" | xargs)
    name=$(echo "$name" | xargs)
    m1=$(echo "$m1" | xargs)
    m2=$(echo "$m2" | xargs)
    m3=$(echo "$m3" | xargs)
    
    # Count subjects where marks < 33 (fail)
    fail_count=0
    [ "$m1" -lt 33 ] && fail_count=$((fail_count + 1))
    [ "$m2" -lt 33 ] && fail_count=$((fail_count + 1))
    [ "$m3" -lt 33 ] && fail_count=$((fail_count + 1))
    
    # Exactly one subject failed
    if [ "$fail_count" -eq 1 ]; then
        echo "$rollno : $name"
        failed_one_count=$((failed_one_count + 1))
    fi
    
    # Passed all subjects (no fails)
    if [ "$fail_count" -eq 0 ]; then
        passed_all_count=$((passed_all_count + 1))
    fi
done < marks.txt

echo ""
echo "=== Students who passed ALL subjects ==="
while IFS=',' read -r rollno name m1 m2 m3; do
    rollno=$(echo "$rollno" | xargs)
    name=$(echo "$name" | xargs)
    m1=$(echo "$m1" | xargs)
    m2=$(echo "$m2" | xargs)
    m3=$(echo "$m3" | xargs)
    
    fail_count=0
    [ "$m1" -lt 33 ] && fail_count=$((fail_count + 1))
    [ "$m2" -lt 33 ] && fail_count=$((fail_count + 1))
    [ "$m3" -lt 33 ] && fail_count=$((fail_count + 1))
    
    if [ "$fail_count" -eq 0 ]; then
        echo "$rollno : $name"
    fi
done < marks.txt

echo ""
echo "=== Summary ==="
echo "Students who failed in exactly ONE subject: $failed_one_count"
echo "Students who passed ALL subjects: $passed_all_count"
