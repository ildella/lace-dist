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
curl -fsSL https://raw.githubusercontent.com/ildella/lace-dist/main/install.sh | bash
```

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
