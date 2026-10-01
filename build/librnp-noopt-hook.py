# MOZ_BUILD_HOOK for Thunderbird Windows ARM64 builds.
#
# Works around a clang-cl optimizer bug that hangs (older clang) or crashes
# (newer clang) while compiling two librnp sources:
#   comm/third_party/rnp/src/rnp/fficli.cpp
#   comm/third_party/rnp/src/rnp/rnpcfg.cpp
# See: https://connect.mozilla.org/t5/ideas/thunderbird-build-for-windows-on-arm/idc-p/87228
#
# The manual workaround (kill the stuck compiler processes, re-run their
# command lines without -O, resume the build) cannot run in CI. Instead, this
# hook — appended to every moz.build file by the build system — clears the
# OPTIMIZE flags for the vendored RNP tree so those files compile without
# optimization. The upstream source tree itself is left completely
# unmodified.
#
# This is the documented mechanism for per-directory flag tweaks:
# https://firefox-source-docs.mozilla.org/setup/configuring_build_options.html
#
# Installed by the workflow via:
#   ac_add_options MOZ_BUILD_HOOK=<abs path>/librnp-noopt-hook.py

if RELATIVEDIR.startswith("comm/third_party/rnp"):
    COMPILE_FLAGS["OPTIMIZE"] = []
