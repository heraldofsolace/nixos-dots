_: {
  pkgs,
  config,
  ...
}: {
  xdg.enable = true;
  xdg = {
    portal = {
      enable = true;
      extraPortals = [config.wayland.windowManager.hyprland.package];
      configPackages = [config.wayland.windowManager.hyprland.package];
    };
  };
}
