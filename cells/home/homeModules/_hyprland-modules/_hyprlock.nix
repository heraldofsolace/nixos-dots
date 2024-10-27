{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.hyprland-suite.hyprlock;
in {
  options.programs.hyprland-suite.hyprlock = {
    enable = lib.mkEnableOption "Enable Hyprlock";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.hyprlock;
      description = "The Hyprlock package to use";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
      package = cfg.package;
      settings = {
        general = {
          grace = 10;
          hide_cursor = false;
          no_fade_in = false;
        };

        background = [
          {
            path = "screenshot";
            blur_passes = 3;
            blur_size = 5;
            noise = 0.0117;
            contrast = 1.6000; # Vibrant!!!
            brightness = 0.5000;
            vibrancy = 0.2500;
            vibrancy_darkness = 0.1000;
          }
        ];

        input-field = [
          {
            size = "500, 50";
            position = "0, -80";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(${config.lib.stylix.colors.base05})";
            inner_color = "rgb(${config.lib.stylix.colors.base00})";
            outer_color = "rgb(${config.lib.stylix.colors.base02})";
            outline_thickness = 5;
            placeholder_text = ''<span foreground="##${config.lib.stylix.colors.base05}">Password</span>'';
            shadow_passes = 2;
          }
        ];

        label = [
          {
            monitor = "";
            text = "$TIME";
            font_size = 50;
            color = "rgb(${config.lib.stylix.colors.base05})";

            position = "0, 150";

            valign = "center";
            halign = "center";
          }
          {
            monitor = "";
            text = "cmd[update:3600000] date +'%a %b %d'";
            font_size = 20;
            color = "rgb(${config.lib.stylix.colors.base05})";

            position = "0, 50";

            valign = "center";
            halign = "center";
          }
        ];
      };
    };
  };
}
