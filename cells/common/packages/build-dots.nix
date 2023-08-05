{writeShellApplication, ...}:
writeShellApplication {
  name = "build-dots";
  text = ''
    OUTPUT="''${1:-./out}"
    TMPDIR="$(mktemp -d)"

    >&2 echo "Building in $OUTPUT..."
    nix build .#md-tangle -o "$TMPDIR/result"

    rm -rf "$OUTPUT"
    mkdir "$OUTPUT"
    cp -rL "$TMPDIR/result"/* -t "$OUTPUT"
    chmod -R +w "$OUTPUT"
  '';
}
