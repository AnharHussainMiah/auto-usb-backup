#!/bin/bash

MOUNT_POINT="/some/mounted/path"
SLEEP_TIME=30
SSH_KEY="/path/to/ssh/key"

# Define your rsync jobs as "source:destination" pairs
RSYNC_JOBS=(
    "/some/source/path|/some/target/path/"
    # Add more jobs as needed
)

PREFIX="[AUTOBACKUP]"

# rsync optionsAdd commentMore actions
RSYNC_OPTS=" -ravz --delete"
# SSH VERSION:
# RSYNC_OPTS=" -ravz --delete -e \"ssh -i $SSH_KEY -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null\""

while true; do
    if mount | grep -q "$MOUNT_POINT"; then
        echo "$PREFIX $MOUNT_POINT is mounted. Starting rsync jobs..."

        for job in "${RSYNC_JOBS[@]}"; do
            SRC="${job%%|*}"
            DEST="${job##*|}"

            echo "$PREFIX Syncing '$SRC' to '$DEST'..."
            echo "$PREFIX DEBUG: rsync $RSYNC_OPTS $SRC $DEST"

            if eval rsync $RSYNC_OPTS "$SRC" "$DEST"; then
                echo "$PREFIX rsync completed successfully! [$SRC]"
            else
                echo "$PREFIX WARNING: - rsync failed for [$SRC]"
            fi
        done
    else
        echo "$PREFIX WARNING: mount doesn't exist or not yet ready"
    fi

    sleep "$SLEEP_TIME"
done
