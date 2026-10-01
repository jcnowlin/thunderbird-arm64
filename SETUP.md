# One-time setup: Windows ARM64 build machine

This workflow does **not** run on GitHub-hosted runners: they expose only
~14 GB free disk and a Thunderbird build needs 40 GB+. It runs on a
**self-hosted Windows ARM64 runner** — e.g. a Surface Pro X. Do the following
once on that machine.

## Machine

- Windows 11 ARM64, **60+ GB free on C:** (the workflow fails fast otherwise).
- Plugged into power; disable sleep while builds run.
- Windows Defender: exclude `C:\tb-build`, `C:\mozilla-build`, and the
  `C:\actions-runner` directory. Without exclusions the build crawls.

## Toolchain (install once)

1. **Visual Studio 2022** (Community is free) with the
   **"Desktop development with C++"** workload. This is the proven toolchain
   for Thunderbird ARM64 builds. (VS 2026 support in Thunderbird's configure
   is unverified as of TB 157 — stick to 2022.)
2. **MozillaBuild 4.2.1** (or newer):
   https://ftp.mozilla.org/pub/mozilla.org/mozilla/libraries/win32/MozillaBuildSetup-Latest.exe —
   install to the default `C:\mozilla-build`.
3. **Rust**: `winget install Rustlang.Rustup`
   (the tree's pinned toolchain installs itself on first build).
4. **Node LTS**: `winget install OpenJS.NodeJS.LTS`
5. **GitHub CLI**: `winget install GitHub.cli` (publishes the releases).
6. **Git**: `winget install Git.Git`
7. `rustup target add aarch64-pc-windows-msvc`
   (no-op on ARM64 Windows, harmless — matches upstream build docs).

## Register the runner

1. In this repo: **Settings → Actions → Runners → New self-hosted runner**,
   choose **Windows** / **ARM64**, and follow the download/configure steps:
   ```powershell
   mkdir C:\actions-runner; cd C:\actions-runner
   # ... download + extract the win-arm64 runner package ...
   .\config.cmd --url https://github.com/jcnowlin/thunderbird-arm64 --token <TOKEN> --labels windows,arm64
   ```
   (`self-hosted` is added automatically; the workflow targets
   `runs-on: [self-hosted, windows, arm64]`.)
2. Run `.\run.cmd` (interactive, minimized is fine). Running as a Windows
   service also works, but the service account needs the full toolchain on
   its PATH — interactive is simpler.
3. `mkdir C:\tb-build` (the workflow creates it if missing, but make sure
   the drive has the free space).

## What happens on first run

- The workflow downloads the official Thunderbird release tarball, verifies
  its SHA512 against Mozilla's published checksums, and extracts it.
- Cold build takes **hours** (estimate 4–8 on a Surface Pro X); leave the
  machine alone. The job timeout is 24 h.
- Subsequent releases reuse the source tree, object dir, and sccache, so
  monthly/chemspill rebuilds are incremental (tens of minutes, not hours).

## Troubleshooting

- **Configure rejects the compiler**: check `vswhere` finds VS 2022 with
  ARM64 C++ tools; the workflow's "Verify toolchain" step reports this.
- **Linker runs out of memory** (8 GB machines): add
  `ac_add_options --disable-lto` to `build/mozconfig.in`.
- **Build hangs in librnp**: the `MOZ_BUILD_HOOK` should prevent the known
  clang-cl optimizer hang; if it recurs, the hook needs attention.
- **Re-run a version**: Actions → workflow → Run workflow, set `version`
  (e.g. `157.0.1`) and `force: true`.
