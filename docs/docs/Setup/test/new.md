---
sidebar_position: 3
---
# Backup & Restore

## restore

View all the dierctory included in the backup
```
tar -tvf /tmp/backup-2025-04-01T03-03-00.tar.gz | grep -E '^d.* /backup/[^/]+$'
```

Extract only home_assistant
```
tar -C /tmp -xvf /backups/server-2/backup-2025-04-01T03-03-00.tar.gz /backup/home_assistant
```

Copy content

```
cp -a /tmp/backup/* /mnt/data/
```
