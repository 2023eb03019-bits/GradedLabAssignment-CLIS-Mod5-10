#!/bin/bash

# Check if log file is provided
if [ $# -ne 1 ]; then
    echo "Error: Log file name required."
    echo "Usage: $0 <logfile>"
    exit 1
fi

logfile="$1"

# Validate file exists and is readable
if [ ! -f "$logfile" ]; then
    echo "Error: File '$logfile' does not exist."
    exit 1
fi

if [ ! -r "$logfile" ]; then
    echo "Error: File '$logfile' is not readable."
    exit 1
fi

# Generate report filename with current date
report_date=$(date +%Y-%m-%d)
report_file="logsummary_${report_date}.txt"

# Count total entries
total_entries=$(wc -l < "$logfile")

# Count by level
info_count=$(grep -c " INFO " "$logfile")
warning_count=$(grep -c " WARNING " "$logfile")
error_count=$(grep -c " ERROR " "$logfile")

# Get most recent ERROR message (last one in file)
latest_error=$(grep " ERROR " "$logfile" | tail -1)

# Generate report
{
    echo "=== Log Analysis Report ==="
    echo "Generated: $(date)"
    echo "Log file: $logfile"
    echo ""
    echo "--- Statistics ---"
    echo "Total log entries: $total_entries"
    echo "INFO messages: $info_count"
    echo "WARNING messages: $warning_count"
    echo "ERROR messages: $error_count"
    echo ""
    echo "--- Most Recent ERROR ---"
    if [ -n "$latest_error" ]; then
        echo "$latest_error"
    else
        echo "No ERROR messages found."
    fi
    echo "===================="
} > "$report_file"

# Display results to terminal
echo "Report generated: $report_file"
echo ""
cat "$report_file"
