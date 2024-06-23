{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.hyprland-suite.hypridle;
in {
  options.programs.hyprland-suite.hypridle = {
    enable = lib.mkEnableOption "Enable Hypridle";
  };

  config = lib.mkIf cfg.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
          lock_cmd = "pidof hyprlock || hass-report-status http://192.168.0.3:8123/api/webhook/eaea48a1-30e3-47bf-a076-30f816f0d3d1 false || hyprlock";
          ignore_dbus_inhibit = false; # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
          ignore_systemd_inhibit = false; # whether to ignore systemd-inhibit --what=idle inhibitors
        };

        listener = [
          {
            timeout = 180;
            on-timeout = ''hass-report-status http://192.168.0.3:8123/api/webhook/eaea48a1-30e3-47bf-a076-30f816f0d3d1 false'';
            on-resume = ''hass-report-status http://192.168.0.3:8123/api/webhook/eaea48a1-30e3-47bf-a076-30f816f0d3d1 true'';
          }
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
            on-resume = "hass-report-status http://192.168.0.3:8123/api/webhook/eaea48a1-30e3-47bf-a076-30f816f0d3d1 true";
          }
          {
            timeout = 330; # 5.5min
            on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
            on-resume = "hyprctl dispatch dpms on && hass-report-status http://192.168.0.3:8123/api/webhook/eaea48a1-30e3-47bf-a076-30f816f0d3d1 true"; # screen on when activity is detected after timeout has fired.
          }
          {
            timeout = 1800;
            on-timeout = "systemctl suspend";
            on-resume = "hass-report-status http://192.168.0.3:8123/api/webhook/eaea48a1-30e3-47bf-a076-30f816f0d3d1 true";
          }
        ];
      };
    };
  };
}
