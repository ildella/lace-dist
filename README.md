# LACE

LACE is a workflow coordinator for agents — harness + context + loop — from
operator-paced to fully automated.

## Requirements

- Linux or macOS (x64, arm64)
- Node.js >= 22.19 on PATH
- `curl` or `wget`
- `sha256sum` or `shasum`
- `tar`
- `~/.local/bin` on PATH

## Install

```bash
curl -fsSL https://github.com/ildella/lace-dist/releases/latest/download/install.sh | bash
```

To install a specific release, such as a nightly build (prereleases tagged
`vX.Y.Z-nightly.YYYYMMDD`), set `LACE_VERSION`:

```bash
curl -fsSL https://github.com/ildella/lace-dist/releases/latest/download/install.sh | LACE_VERSION=v0.8.0-nightly.20261014 bash
```

The installer records the tool paths and writes the systemd user units for your
registered projects, then prints the one next step (`lace service start`).

## Update

```bash
lace update
```

## Check

```bash
lace doctor
```

## Uninstall

Remove the LACE files:

```bash
node ~/.lace/uninstall.js
```

Also remove the user config and the runtime state of registered projects:

```bash
node ~/.lace/uninstall.js --purge
```

## Source

https://github.com/ildella/lace
