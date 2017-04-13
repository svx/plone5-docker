#!/bin/bash

echo "Fixing permissions for external /data volumes"
mkdir -vp /data/log && touch /data/log/instance.log
chown -Rv plone:plone /data

exec gosu plone ./plone-entrypoint.sh "$@"
