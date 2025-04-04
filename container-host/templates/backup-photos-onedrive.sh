#!/bin/bash

# Get today's date
TODAY=$(date +%Y-%m-%d)

# Calculate the date 5 days ago
TARGET_DATE=$(date -d '15 days ago' +%Y-%m-%d)

# Convert dates to seconds since epoch for comparison
TODAY_EPOCH=$(date -d "$TODAY" +%s)
TARGET_DATE_EPOCH=$(date -d "$TARGET_DATE" +%s)

DEST_DIR="library-$TODAY"

# copy all photos to onedrive
/usr/bin/rclone copy /photos/library onedrive-system:/photos-backup/$DEST_DIR

# Get a list of all directories, sort them, and keep only the last 5
DIRECTORIES=($(rclone lsf --dirs-only onedrive-system:/photos-backup | sort ))

# Calculate the number of directories to delete
NUM_DIRECTORIES=${#DIRECTORIES[@]}
NUM_TO_DELETE=$((NUM_DIRECTORIES - 5))

# Keep only 5 latest directories
if [ $NUM_TO_DELETE -gt 0 ]; then
    for ((i=0; i<NUM_TO_DELETE; i++)); do
        DIR_NAME=${DIRECTORIES[$i]}
        # Remove the trailing slash from the directory name for rclone purge
        DIR_NAME=$(echo "$DIR_NAME" | sed 's:/*$::')
        # Delete the directory and its contents
        /usr/bin/rclone purge onedrive-system:/photos-backup/"$DIR_NAME"
        echo "Deleted: $DIR_NAME"
    done
fi
