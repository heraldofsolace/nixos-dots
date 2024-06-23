_: {
  pkgs,
  config,
  lib,
  ...
}: {
  # xdg.desktopEntries."org.gnome.Settings" = {
  #   name = "Settings";
  #   comment = "Gnome Control Center";
  #   icon = "org.gnome.Settings";
  #   exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome.gnome-control-center}/bin/gnome-control-center";
  #   categories = ["X-Preferences"];
  #   terminal = false;
  # };
  # wayland.windowManager.hyprland.enable = true;
  # wayland.windowManager.hyprland.systemd.variables = ["--all"];
  # wayland.windowManager.hyprland.settings = let
  #   # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
  #   workspaces = builtins.concatLists (builtins.genList (
  #       x: let
  #         ws = let
  #           c = (x + 1) / 10;
  #         in
  #           builtins.toString (x + 1 - (c * 10));
  #       in [
  #         "$mod, ${ws}, workspace, ${toString (x + 1)}"
  #         "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
  #       ]
  #     )
  #     10);
  #   yt = pkgs.writeShellScript "yt" ''
  #     notify-send "Opening video" "$(wl-paste)"
  #     mpv "$(wl-paste)"
  #   '';

  #   playerctl = "${pkgs.playerctl}/bin/playerctl";
  #   brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  #   wpctl = "${pkgs.wireplumber}/bin/wpctl";
  #   wallpaper-day = ./_files/wallpaper-day.gif;
  #   wallpaper-evening = ./_files/wallpaper-evening.gif;
  #   wallpaper-night = ./_files/wallpaper-night.gif;
  # in {
  #   "$mod" = "SUPER";
  #   exec-once = [
  #     "aags"
  #     "swww-schedule ${wallpaper-day} 05:00"
  #     "swww-schedule ${wallpaper-evening} 17:00"
  #     "swww-schedule ${wallpaper-night} 20:00"
  #     "${pkgs.kwallet-pam}/libexec/pam_kwallet_init"
  #     "/nix/store/$(ls -la /nix/store | grep polkit-kde-agent | grep '^d' | awk '{print $9}')/libexec/polkit-kde-authentication-agent-1"
  #   ];
  #   exec = [
  #     "hyprshade auto"
  #     "hass-report-status http://192.168.0.3:8123/api/webhook/eaea48a1-30e3-47bf-a076-30f816f0d3d1 true"
  #   ];

  #   animations = {
  #     enabled = true;
  #     animation = [
  #       "border, 1, 2, default"
  #       "fade, 1, 4, default"
  #       "windows, 1, 3, default, popin 80%"
  #       "workspaces, 1, 2, default, slide"
  #     ];
  #   };

  #   group = {
  #     groupbar = {
  #       font_size = 10;
  #       gradients = false;
  #       text_color = "rgb(${config.lib.stylix.colors.base05})";
  #     };
  #   };
  #   bind = let
  #     monocle = "dwindle:no_gaps_when_only";
  #     e = "exec, ${pkgs.aags}";
  #   in
  #     [
  #       "SUPER, Return, exec, kitty"
  #       "SUPER ALT, Q, ${e} -t powermenu'"
  #       "SUPER, Q, killactive"
  #       "$mod, F, exec, firefox"
  #       "Control&Alt, L, exec, hyprlock"
  #       "$mod, F, fullscreen,"
  #       "$mod, G, togglegroup,"
  #       "$mod SHIFT, N, changegroupactive, f"
  #       "$mod SHIFT, P, changegroupactive, b"
  #       "$mod, R, togglesplit,"
  #       "$mod, T, togglefloating,"
  #       "$mod, P, pseudo,"
  #       "$mod ALT, ,resizeactive,"
  #       "$mod, M, exec, hyprctl keyword ${monocle} $(($(hyprctl getoption ${monocle} -j | jaq -r '.int') ^ 1))"

  #       # move focus
  #       "$mod, a, movefocus, l"
  #       "$mod, h, movefocus, r"
  #       "$mod, i, movefocus, u"
  #       "$mod, e, movefocus, d"

  #       # screenshot
  #       # area
  #       '', Print, ${e} -r 'recorder.screenshot(true,"area")' ''

  #       # current screen
  #       ''CTRL, Print,${e} -r 'recorder.screenshot(true,"output")' ''

  #       # all screen
  #       ''ALT, Print, ${e} -r 'recorder.screenshot(true,"screen")' ''

  #       # special workspace
  #       "$mod SHIFT, grave, movetoworkspace, special"
  #       "$mod, grave, togglespecialworkspace, eDP-1"

  #       # cycle workspaces
  #       "$mod, bracketleft, workspace, m-1"
  #       "$mod, bracketright, workspace, m+1"

  #       # cycle monitors
  #       "$mod SHIFT, bracketleft, focusmonitor, l"
  #       "$mod SHIFT, bracketright, focusmonitor, r"

  #       # send focused workspace to left/right monitors
  #       "$mod SHIFT ALT, bracketleft, movecurrentworkspacetomonitor, u"
  #       "$mod SHIFT ALT, bracketright, movecurrentworkspacetomonitor, d"

  #       "$mod, S, togglespecialworkspace, magic"
  #       "$mod, S, movetoworkspace, +0"
  #       "$mod, S, togglespecialworkspace, magic"
  #       "$mod, S, movetoworkspace, special:magic"
  #       "$mod, S, togglespecialworkspace, magic"
  #     ]
  #     ++ workspaces;
  #   bindl = [
  #     ", XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"
  #     ",XF86AudioPlay,    exec, ${playerctl} play-pause"
  #     ",XF86AudioStop,    exec, ${playerctl} pause"
  #     ",XF86AudioPause,   exec, ${playerctl} pause"
  #     ",XF86AudioPrev,    exec, ${playerctl} previous"
  #     ",XF86AudioNext,    exec, ${playerctl} next"
  #   ];
  #   bindr = [
  #     "SUPER, L, exec, pkill rofi || rofi -show drun"
  #   ];
  #   bindel = [
  #     ", XF86AudioRaiseVolume, exec, ${wpctl} set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"
  #     ", XF86AudioLowerVolume, exec, ${wpctl} set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"
  #     ",XF86MonBrightnessUp,   exec, ${brightnessctl} set +5%"
  #     ",XF86MonBrightnessDown, exec, ${brightnessctl} set  5%-"
  #   ];
  #   bindm = [
  #     "ALT,mouse:272,movewindow"
  #   ];
  #   monitor = [
  #     "HDMI-A-1,3840x2160,0x0,1"
  #     "DP-3,2560x1440,-2560x0,1"
  #     ",preferred,auto,1"
  #   ];
  #   layerrule = [
  #     "blur,rofi"
  #   ];
  #   "debug:disable_logs" = "false";
  # };
  # wayland.windowManager.hyprland.extraConfig = ''
  #   # window resize
  #   bind = $mod, S, submap, resize

  #   submap = resize
  #   binde = , h, resizeactive, 10 0
  #   binde = , a, resizeactive, -10 0
  #   binde = , i, resizeactive, 0 -10
  #   binde = , e, resizeactive, 0 10
  #   bind = , escape, submap, reset
  #   submap = reset
  # '';
  # programs.kitty.enable = true;
  # programs.hyprlock = {
  #   enable = true;
  #   settings = {
  #     general = {
  #       grace = 10;
  #       hide_cursor = true;
  #       no_fade_in = false;
  #     };

  #     background = [
  #       {
  #         path = "screenshot";
  #         blur_passes = 5;
  #         blur_size = 8;
  #       }
  #     ];

  #     input-field = [
  #       {
  #         size = "500, 50";
  #         position = "0, -80";
  #         monitor = "";
  #         dots_center = true;
  #         fade_on_empty = false;
  #         font_color = "##${config.lib.stylix.colors.base05}";
  #         inner_color = "##${config.lib.stylix.colors.base00}";
  #         outer_color = "##${config.lib.stylix.colors.base02}";
  #         outline_thickness = 5;
  #         placeholder_text = ''<span foreground="##${config.lib.stylix.colors.base05}">Password</span>'';
  #         shadow_passes = 2;
  #       }
  #     ];

  #     label = [
  #       {
  #         monitor = "";
  #         text = "$TIME";
  #         font_size = 50;
  #         color = "##${config.lib.stylix.colors.base05}";

  #         position = "0, 150";

  #         valign = "center";
  #         halign = "center";
  #       }
  #       {
  #         monitor = "";
  #         text = "cmd[update:3600000] date +'%a %b %d'";
  #         font_size = 20;
  #         color = "##${config.lib.stylix.colors.base05}";

  #         position = "0, 50";

  #         valign = "center";
  #         halign = "center";
  #       }
  #     ];
  #   };
  # };
  # # programs.wpaperd.enable = true;
  # # services.swayosd.enable = true;
  # services.hass-report-usage.enable = lib.mkForce false;
  # services.hypridle = {
  #   enable = true;
  #   settings = {
  #     general = {
  #       before_sleep_cmd = "loginctl lock-session";
  #       after_sleep_cmd = "hyprctl dispatch dpms on";
  #       lock_cmd = "pidof hyprlock || hass-report-status http://192.168.0.3:8123/api/webhook/eaea48a1-30e3-47bf-a076-30f816f0d3d1 false || hyprlock";
  #       ignore_dbus_inhibit = false; # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
  #       ignore_systemd_inhibit = false; # whether to ignore systemd-inhibit --what=idle inhibitors
  #     };

  #     listener = [
  #       {
  #         timeout = 180;
  #         on-timeout = ''hass-report-status http://192.168.0.3:8123/api/webhook/eaea48a1-30e3-47bf-a076-30f816f0d3d1 false'';
  #         on-resume = ''hass-report-status http://192.168.0.3:8123/api/webhook/eaea48a1-30e3-47bf-a076-30f816f0d3d1 true'';
  #       }
  #       {
  #         timeout = 300;
  #         on-timeout = "loginctl lock-session";
  #         on-resume = "hass-report-status http://192.168.0.3:8123/api/webhook/eaea48a1-30e3-47bf-a076-30f816f0d3d1 true";
  #       }
  #       {
  #         timeout = 330; # 5.5min
  #         on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
  #         on-resume = "hyprctl dispatch dpms on && hass-report-status http://192.168.0.3:8123/api/webhook/eaea48a1-30e3-47bf-a076-30f816f0d3d1 true"; # screen on when activity is detected after timeout has fired.
  #       }
  #       {
  #         timeout = 1800;
  #         on-timeout = "systemctl suspend";
  #         on-resume = "hass-report-status http://192.168.0.3:8123/api/webhook/eaea48a1-30e3-47bf-a076-30f816f0d3d1 true";
  #       }
  #     ];
  #   };
  # };
  # services.network-manager-applet.enable = true;
  # home.packages = with pkgs; [
  #   hyprshade
  #   grimblast
  #   uptime-nixos
  #   hass-report-status
  #   jaq
  # ];

  # xdg.configFile."hypr/hyprshade.toml" = {
  #   text = ''
  #     [[shades]]
  #     name = "vibrance"
  #     default = true

  #     [[shades]]
  #     name = "blue-light-filter"
  #     start_time = 19:00:00
  #     end_time = 06:00:00
  #   '';
  # };

  desktop.hyprland-suite.enable = true;
  services.hass-report-usage.enable = lib.mkForce false;
}
