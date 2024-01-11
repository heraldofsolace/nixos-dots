# Nix Configuration

This repository is home to the nix code that builds my systems.

## Why Nix?

Nix allows for easy to manage, collaborative, reproducible deployments. This means that once something is setup and configured once, it works forever. If someone else shares their configuration, anyone can make use of it.

This flake is configured with the use of [hive][hive].

## Apply configs

### NixOS hosts

```bash
colmena build
colmena apply
# OR
colmena apply --on "nixos-$HOST"
```

### Darwin hosts

```bash
darwin-rebuild switch --flake .
```

[hive]: https://github.com/divnix/hive

# backstage-k8s
