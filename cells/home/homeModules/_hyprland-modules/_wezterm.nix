{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.hyprland-suite.wezterm;
in {
  options.programs.hyprland-suite.wezterm = {
    enable = lib.mkEnableOption "Enable Wezterm";
  };

  config = lib.mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      extraConfig = ''
        local config = wezterm.config_builder()
        config.enable_wayland = false
        return config
      '';
    };
  };
}
