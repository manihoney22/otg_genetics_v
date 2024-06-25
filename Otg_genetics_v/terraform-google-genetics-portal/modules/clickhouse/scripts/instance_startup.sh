#!/bin/bash

echo "[LAUNCH] Open Targets Genetics Portal Clickhouse DB"

echo "Prepare CH disk mount"
ch_mount="/mnt/disks"
ch_serv="$ch_mount/var/lib/clickhouse"
ch_conf="$ch_mount/etc/clickhouse-server/config.d"
ch_user="$ch_mount/etc/clickhouse-server/user.d"

sudo mount -o discard,defaults /dev/disk/by-id/google-${CLICKHOUSE_DEVICE_ID} $ch_mount
echo "Mount status exit code: $?"
# start Clickhouse
# https://hub.docker.com/r/clickhouse/clickhouse-server/
echo "---> Starting Clickhouse Docker image"
docker run -d \
    -p 8123:8123 \
    -p 9000:9000 \
    --name clickhouse \
    --mount type=bind,source=$ch_serv,target=/var/lib/clickhouse \
    --mount type=bind,source=$ch_conf,target=/etc/clickhouse-server/config.d \
    --mount type=bind,source=$ch_user,target=/etc/clickhouse-server/users.d \
    --ulimit nofile=262144:262144 \
    clickhouse/clickhouse-server:${CLICKHOUSE_VERSION}

sleep 300