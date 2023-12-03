#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

host_spawn_version='1.5.0'

curl -SLo /tmp/host-spawn "https://github.com/1player/host-spawn/releases/download/${host_spawn_version}/host-spawn-$(uname -m)"
mv /tmp/host-spawn /usr/bin/
chmod +x /usr/bin/host-spawn
