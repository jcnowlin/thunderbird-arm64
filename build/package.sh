#!/bin/bash
# Thunderbird Windows ARM64 packaging driver: produces the .installer.exe.
# Invoked by the GitHub workflow inside MozillaBuild's MSYS2 bash:
#   C:\mozilla-build\msys2\usr\bin\bash.exe --login /c/tb-build/package.sh
# Keep Unix (LF) line endings — see .gitattributes.
set -euo pipefail

export MOZILLABUILD=/c/mozilla-build
export MOZCONFIG=/c/tb-build/mozconfig
export SCCACHE_DIR=/c/tb-build/sccache
export SCCACHE_CACHE_SIZE=10G

cd /c/tb-build/source
./mach package
