#!/bin/bash

# Define variables
SOURCE_DIR="/photos/library"
BUCKET_NAME="photos-cloudstack"
CURRENT_DATE=$(date +"%Y-%m-%d")
DEST_DIR="library-$CURRENT_DATE"

# Copy the directory to S3 Glacier
aws s3 cp "$SOURCE_DIR" "s3://$BUCKET_NAME/$DEST_DIR/" --recursive --storage-class DEEP_ARCHIVE
