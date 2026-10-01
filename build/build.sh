#!/bin/bash
# Thunderbird Windows ARM64 build driver.
# Invoked by the GitHub workflow inside MozillaBuild's MSYS2 bash:
#   C:\mozilla-build\msys2\usr\bin\bash.exe --login /c/tb-build/build.sh
# Keep Unix (LF) line endings — see .gitattributes.
set -euo pipefail

export MOZILLABUILD=/c/mozilla-build
export MOZCONFIG=/c/tb-build/mozconfig

# Persistent sccache on local disk: cold on the first build, warm afterwards.
# The build system downloads the sccache binary automatically.
export SCCACHE_DIR=/c/tb-build/sccache
export SCCACHE_CACHE_SIZE=10G

cd /c/tb-build/source
./mach build
