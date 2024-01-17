#! /usr/bin/env bash
printf "pkgs:\n{\n" >generated.nix
while read line; do
  printf "$(echo $line | awk '{print $2}') = " >>generated.nix
  nix-prefetch-github --nix $line | sed 1,3d >>generated.nix
  printf ";\n" >>generated.nix
done <pluginNames
printf "}" >>generated.nix
