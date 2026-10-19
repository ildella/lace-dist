# LACE

LACE is a workflow coordinator for agents — harness + context + loop — from
operator-paced to fully automated.

## Requirements

- **Node.js >= 22.19 on PATH — required** (check: `node -v`)
- Linux or macOS (x64, arm64)
- `curl` or `wget`
- `sha256sum` or `shasum`
- `tar`
- `~/.local/bin` on PATH (the installer prints the line to add when missing)

LACE does not bundle a Node runtime: upgrade your Node before installing if
`node -v` is older than 22.19.

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

## First project

From any repo — pnpm monorepo, single package, anything:

```bash
lace init            # register it; writes .lace/lace.jsonc (commit it)
lace doctor          # check the machine and the project are ready
lace service start   # start the always-on loops (systemd Linux)
```

No Yarn, no assumed package manager, no assumed tracker.

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
