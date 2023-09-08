VERSION 0.7
FROM nixos/nix:2.17.0
WORKDIR /nix-hosts

deps:
    ENV NIX=nix --extra-experimental-features nix-command --extra-experimental-features flakes
    RUN nix-env -iA cachix -f https://cachix.org/api/v1/install
    RUN nix-channel --add https://nixos.org/channels/nixpkgs-unstable && nix-channel --update
    RUN git config --global --add safe.directory "$(pwd)"
    RUN cachix use nix-community && cachix use mic92 && cachix use nrdxp

build-host:
    ARG HOST=undefined
    FROM +deps
    COPY . .
    RUN --secret CACHIX_AUTH_TOKEN -- cachix watch-exec heraldofsolace  --compression-method xz --compression-level 9 --jobs 2  -- $NIX build ".#nixosConfigurations.$HOST.config.system.build.toplevel"

build-nixos-andromeda:
    BUILD build-host --HOST=nixos-andromeda

build-nixos-horologium:
    BUILD build-host --HOST=nixos-horologium

build-nixos-miranda:
    BUILD build-host --HOST=nixos-miranda