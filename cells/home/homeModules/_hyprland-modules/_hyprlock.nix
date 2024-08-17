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
  };

  config = lib.mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          grace = 10;
          hide_cursor = false;
          no_fade_in = false;
        };

        background = [
          {
            path = "screenshot";
            blur_passes = 5;
            blur_size = 6;
          }
        ];

        input-field = [
          {
            size = "500, 50";
            position = "0, -80";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "##${config.lib.stylix.colors.base05}";
            inner_color = "##${config.lib.stylix.colors.base00}";
            outer_color = "##${config.lib.stylix.colors.base02}";
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
            color = "##${config.lib.stylix.colors.base05}";

            position = "0, 150";

            valign = "center";
            halign = "center";
          }
          {
            monitor = "";
            text = "cmd[update:3600000] date +'%a %b %d'";
            font_size = 20;
            color = "##${config.lib.stylix.colors.base05}";

            position = "0, 50";

            valign = "center";
            halign = "center";
          }
        ];
      };
    };
  };
}
