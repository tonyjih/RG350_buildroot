#!/usr/bin/env bash

set -euo pipefail

mkdir -p dl/od_local_pack/
cd dl/od_local_pack/

echo Downloading rs97.bitgala.xyz/RG-350/localpack/emulators/...
wget -N -r -nd --no-parent --reject='index.html*' --reject='scumm*' --reject='robots.txt*' \
https://rs97.bitgala.xyz/RG-350/localpack/default_emulators/ |& tee /tmp/emulators.log

echo Downloading rs97.bitgala.xyz/RG-350/localpack/apps/...
wget -N -r -nd --no-parent --reject='index.html*' --reject='robots.txt*' \
https://rs97.bitgala.xyz/RG-350/localpack/default_apps/ |& tee /tmp/apps.log
