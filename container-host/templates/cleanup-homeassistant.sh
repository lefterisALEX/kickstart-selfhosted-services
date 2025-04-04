#!/bin/bash
find /mnt/data/home_assistant/backups/ -type f -mtime +10 -exec rm {} \;
