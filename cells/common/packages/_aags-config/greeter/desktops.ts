import { bash } from "lib/utils";

const names = (
  await bash(
    "sed -n 's/ *Name=\\(.*\\)$/\\1/p' /run/current-system/sw/share/{wayland-,x}sessions/*.desktop",
  )
).split("\n");
const commands = (
  await bash(
    "sed -n 's/^Exec=\\(.*\\)$/\\1/p' /run/current-system/sw/share/{wayland-,x}sessions/*.desktop",
  )
).split("\n");

const desktops = names.map((name, i) => ({ name, command: commands[i] }));
