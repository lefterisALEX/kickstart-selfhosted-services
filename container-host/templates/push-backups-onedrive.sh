#!/bin/bash
set -e
/usr/bin/rclone copy /backups onedrive-system:/backups/cloudstack
echo > /tmp/push-backups-done
curl  https://hc-ping.com/d9339d29-a1a7-48e6-9e2f-edb3a71260cd
echo > /tmp/curl-healthchecks-done
