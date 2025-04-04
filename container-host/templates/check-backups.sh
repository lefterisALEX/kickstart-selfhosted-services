#!/bin/bash

# Define directories to check
directories=("/backups/zigbee" "/backups/server-2" "/backups/server-2/immich-postgres/db_dumps/daily/" "/backups/openwrt/core/" )

# Variable to track if all checks are successful
all_checks_successful=true

# Loop through each directory
for dir in "${directories[@]}"; do
    # Check if directory exists
    if [ -d "$dir" ]; then
        # Find files created in the last 24 hours
        recent_files=$(find "$dir" -type f -ctime -1)

        # If no recent files are found, set the flag to false
        if [ -z "$recent_files" ]; then
            echo "No recent files found in $dir"
            all_checks_successful=false
        fi
    else
        echo "Directory $dir does not exist."
        all_checks_successful=false
    fi
done

# If all checks are successful, perform cURL request
if $all_checks_successful; then
    echo "All checks successful. Performing cURL request..."
    curl -X GET "https://hc-ping.com/f342526b-ff3e-4963-b41a-51bf9cc937b1"
else
    echo "Some checks failed. Not performing cURL request."
fi
