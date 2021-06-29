#!/usr/bin/env bash

if [ ! -d "/tmp/model" ]; then
  echo "ERROR: DIRECTORY /tmp/model MISSING"
  echo "    Mount model directory using '-v <path>:/tmp/model'"
  exit 2
fi

if [ ! -d "/tmp/html" ]; then
  echo "ERROR: DIRECTORY /tmp/html MISSING"
  echo "    Mount HTML output directory using '-v <path>:/tmp/html'"
  exit 3
fi

# With help from https://github.com/ws-skeleton/eclipse-broadway/blob/9b58f8c23daaa251fba0e314e9bf6e681949cbea/init.sh#L12-L15
echo "STARTING DBUS DAEMON"

export DESKTOP=:1
mkdir -p /var/run/dbus
dbus-daemon --system --fork &
export DBUS_SESSION_BUS_ADDRESS=$(dbus-daemon --session --fork --print-address)
export NO_AT_BRIDGE=1

echo "STARTING ARCHI"

/usr/bin/xvfb-run --server-num 1 \
  /opt/Archi/Archi \
    -application com.archimatetool.commandline.app \
    -consoleLog -nosplash --abortOnException \
    --modelrepository.loadModel "/tmp/model" \
    --html.createReport "/tmp/html"

echo "DONE"
