{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.hyprland-suite.waybar;
in {
  options.programs.hyprland-suite.waybar = {
    enable = lib.mkEnableOption "Enable Waybar";
  };

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      style = ''
        * {
            font-size: ${builtins.toString (builtins.mul config.stylix.fonts.sizes.desktop 1.5)}pt;
        }
        #custom-notification {
          font-family: "NotoSansMono Nerd Font";
        }
      '';
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          output = [
            "HDMI-A-1"
            "DP-1"
          ];
          modules-left = ["hyprland/workspaces" "hyprland/language" "network#enp6s0" "wlr/taskbar"];
          modules-center = ["hyprland/window"];
          modules-right = ["tray" "custom/notification" "wireplumber" "clock"];
          "wlr/taskbar" = {
            format = "{icon}";
            icon-size = 14;
          };
          "network#enp6s0" = {
            interval = 1;
            interface = "enp6s0";
            format-icons = ["󰈀"];
            format-ethernet = "{icon}";
            format-disconnected = "";
            on-click = "";
            tooltip = true;
            tooltip-format = "󰢮 {ifname}\n󰩟 {ipaddr}/{cidr}\n󰞒 {bandwidthDownBytes}\n󰞕 {bandwidthUpBytes}";
          };
          "hyprland/workspaces" = {
            all-outputs = true;
            format = "{icon}";
            format-icons = {
              "1" = "1";
              "2" = "2";
              "3" = "3";
              "4" = "4";
              "urgent" = "";
              "focused" = "";
              "default" = "";
            };
          };
          clock = {
            format = "  {:%H:%M   %e %b}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            today-format = "<b>{}</b>";
          };
          wireplumber = {
            scroll-step = 5;
            format = "{icon} {volume}%";
            format-muted = "";
            on-scroll-up = "swayosd-client --output-volume +5";
            on-scroll-down = "swayosd-client --output-volume -5";
            format-icons = ["" "" ""];
          };
          tray = {
            icon-size = 14;
            spacing = 8;
          };
          "custom/notification" = {
            tooltip = false;
            format = "{} {icon}";
            format-icons = {
              notification = "󱅫";
              none = "󰂚";
              dnd-notification = "󰂛";
              dnd-none = "󰂛";
              inhibited-notification = "󱅫";
              inhibited-none = "󰂚";
              dnd-inhibited-notification = "󰂛";
              dnd-inhibited-none = "󰂛";
            };
            return-type = "json";
            exec-if = "which swaync-client";
            exec = "swaync-client -swb";
            on-click = "swaync-client -t -sw";
            on-click-right = "swaync-client -d -sw";
            escape = true;
          };
        };
      };
    };
  };
}
