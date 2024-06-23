{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.hyprland-suite.hyprshade;
in {
  options.programs.hyprland-suite.hyprshade = {
    enable = lib.mkEnableOption "Enable Hyprshade";
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."hypr/hyprshade.toml" = {
      text = ''
        [[shades]]
        name = "vibrance"
        default = true

        [[shades]]
        name = "blue-light-filter"
        start_time = 19:00:00
        end_time = 06:00:00
      '';
    };
  };
}
