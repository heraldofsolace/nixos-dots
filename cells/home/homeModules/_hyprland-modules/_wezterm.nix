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
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.wezterm;
      description = "The Wezterm package to use";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      package = cfg.package;
      extraConfig = ''
        local config = wezterm.config_builder()
        config.enable_wayland = true
        return config
      '';
    };
  };
}
