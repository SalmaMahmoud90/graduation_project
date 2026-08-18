#!/bin/bash
set -euo pipefail

# Run from the script's own directory so relative paths (.venv, manage.py)
# resolve regardless of where systemd / the shell launches it from.
cd "$(dirname "$0")"

# Activate the virtual environment
source .venv/bin/activate

# HTTP API only. WebSockets are served by a separate single-process daphne
# service (start-ws.sh); nginx routes /ws/ there. Keeping HTTP on WSGI lets us
# run many workers for throughput without touching Django Channels (the HTTP
# path never uses the channel layer).
exec gunicorn carpolling.wsgi:application \
    --no-control-socket \
    --workers 10 \
    --bind 127.0.0.1:3015 \
    --timeout 120 \
    --graceful-timeout 30 \
    --worker-tmp-dir /dev/shm \
    --access-logfile - \
    --error-logfile -
