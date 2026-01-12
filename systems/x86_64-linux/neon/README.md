# Database Dumps

See https://www.postgresql.org/docs/current/backup-dump.html for more.

## Dumping

```sh
ssh root@neon -o RemoteCommand="sudo -u postgres pg_dumpall > /tmp/dump.sql" && scp root@neon:/tmp/dump.sql ./dump.sql
```

## Restoring

```sh
scp ./dump.sql root@neon:/tmp/dump.sql && ssh root@neon -o RemoteCommand="sudo -u postgres psql -X -f /tmp/dump.sql postgres"
```
