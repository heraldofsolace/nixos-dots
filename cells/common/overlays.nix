{
  inputs,
  cell,
}: {
  common-packages = _: _: cell.packages;
  latest-overrides = _: _: cell.overrides;
  nur = inputs.nur.overlay;
  agenix = inputs.agenix.overlays.default;
  nvfetcher = inputs.nvfetcher.overlays.default;
  hyprland-contrib = inputs.hyprland-contrib.overlays.default;
}
