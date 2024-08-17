{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.hyprland-suite;
in {
  imports = [
    ./_hyprland-modules/_ags.nix
    ./_hyprland-modules/_hypridle.nix
    ./_hyprland-modules/_hyprlock.nix
    ./_hyprland-modules/_hyprshade.nix
    ./_hyprland-modules/_rofi.nix
    ./_hyprland-modules/_waybar.nix
    ./_hyprland-modules/_wezterm.nix
  ];
  options.desktop.hyprland-suite = {
    enable = lib.mkEnableOption "Enable Hyprland suite";
    enableAGS = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    enableHypridle = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    enableHyprlock = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    enableHyprshade = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    enableRofi = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    enableWaybar = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    enableWezterm = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    enableHASSReportStatus = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = let
    terminal =
      if cfg.enableWezterm
      then "wezterm"
      else "kitty";
  in
    lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        hyprshade
        grimblast
        uptime-nixos
        hass-report-status
        jaq
        playerctl
        brightnessctl
        wireplumber
        swww-schedule
        kwallet-pam
      ];

      programs.${terminal}.enable = true;
      programs.hyprland-suite.wezterm.enable = cfg.enableWezterm;
      programs.hyprland-suite.waybar.enable = cfg.enableWaybar;
      programs.hyprland-suite.rofi.enable = cfg.enableRofi;
      programs.hyprland-suite.hyprshade.enable = cfg.enableHyprshade;
      programs.hyprland-suite.hyprlock.enable = cfg.enableHyprlock;
      programs.hyprland-suite.hypridle.enable = cfg.enableHypridle;
      programs.hyprland-suite.ags.enable = cfg.enableAGS;

      services.hyprpaper.enable = lib.mkForce false;

      xdg.desktopEntries."org.gnome.Settings" = {
        name = "Settings";
        comment = "Gnome Control Center";
        icon = "org.gnome.Settings";
        exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome.gnome-control-center}/bin/gnome-control-center";
        categories = ["X-Preferences"];
        terminal = false;
      };
      wayland.windowManager.hyprland.enable = true;
      wayland.windowManager.hyprland.systemd.variables = ["--all"];
      wayland.windowManager.hyprland.settings = let
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        workspaces = builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10);
        yt = pkgs.writeShellScript "yt" ''
          notify-send "Opening video" "$(wl-paste)"
          mpv "$(wl-paste)"
        '';

        playerctl = "${pkgs.playerctl}/bin/playerctl";
        brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
        wpctl = "${pkgs.wireplumber}/bin/wpctl";
        wallpaper-day = ./_files/wallpaper-day.gif;
        wallpaper-evening = ./_files/wallpaper-evening.gif;
        wallpaper-night = ./_files/wallpaper-night.gif;
      in {
        "$mod" = "SUPER";
        exec-once =
          [
            "swww-daemon"
            "swww-schedule -i \"${wallpaper-day};05:00\" -i \"${wallpaper-night};17:00\""
            "${pkgs.kwallet-pam}/libexec/pam_kwallet_init"
            "/nix/store/$(ls -la /nix/store | grep polkit-kde-agent | grep '^d' | awk '{print $9}')/libexec/polkit-kde-authentication-agent-1"
          ]
          ++ (
            if cfg.enableAGS
            then ["aags"]
            else []
          );
        exec =
          (
            if cfg.enableHyprshade
            then ["hyprshade auto"]
            else []
          )
          ++ (
            if cfg.enableHASSReportStatus
            then [
              "hass-report-status http://192.168.0.3:8123/api/webhook/eaea48a1-30e3-47bf-a076-30f816f0d3d1 true"
            ]
            else []
          );

        animations = {
          enabled = true;
          animation = [
            "border, 1, 2, default"
            "fade, 1, 4, default"
            "windows, 1, 3, default, popin 80%"
            "workspaces, 1, 2, default, slide"
          ];
        };

        group = {
          groupbar = {
            font_size = 10;
            gradients = false;
            text_color = "rgb(${config.lib.stylix.colors.base05})";
          };
        };
        bind = let
          monocle = "dwindle:no_gaps_when_only";
          e = "exec, ${pkgs.aags}/bin/aags";
        in
          [
            "SUPER, Return, exec, ${terminal}"
            "SUPER ALT, Q, ${e} -t powermenu"
            "CTRL SHIFT, R,  ${e} quit; ${pkgs.aags}/bin/aags"
            "SUPER, Q, killactive"
            "Control&Alt, L, exec, hyprlock"
            "$mod, F, fullscreen,"
            "$mod, G, togglegroup,"
            "$mod SHIFT, N, changegroupactive, f"
            "$mod SHIFT, P, changegroupactive, b"
            "$mod, R, togglesplit,"
            "$mod, T, togglefloating,"
            "$mod, P, pseudo,"
            "$mod ALT, ,resizeactive,"
            "$mod, M, exec, hyprctl keyword ${monocle} $(($(hyprctl getoption ${monocle} -j | jaq -r '.int') ^ 1))"

            # move focus
            "$mod, a, movefocus, l"
            "$mod, h, movefocus, r"
            "$mod, i, movefocus, u"
            "$mod, e, movefocus, d"
            ", XF86Launch1,  exec, ${yt}"

            # screenshot
            # area
            '', Print, ${e} -r 'recorder.screenshot(true,"area")' ''

            # current screen
            ''CTRL, Print,${e} -r 'recorder.screenshot(true,"output")' ''

            # all screen
            ''ALT, Print, ${e} -r 'recorder.screenshot(true,"screen")' ''

            # special workspace
            "$mod SHIFT, grave, movetoworkspace, special"
            "$mod, grave, togglespecialworkspace, eDP-1"

            # cycle workspaces
            "$mod, bracketleft, workspace, m-1"
            "$mod, bracketright, workspace, m+1"

            # cycle monitors
            "$mod SHIFT, bracketleft, focusmonitor, l"
            "$mod SHIFT, bracketright, focusmonitor, r"

            # send focused workspace to left/right monitors
            "$mod SHIFT ALT, bracketleft, movecurrentworkspacetomonitor, u"
            "$mod SHIFT ALT, bracketright, movecurrentworkspacetomonitor, d"

            "$mod, M, togglespecialworkspace, magic"
            "$mod, M, movetoworkspace, +0"
            "$mod, M, togglespecialworkspace, magic"
            "$mod, M, movetoworkspace, special:magic"
            "$mod, M, togglespecialworkspace, magic"

            "SUPER, L,       ${e} -t launcher"
            "SUPER, Tab,     ${e} -t overview"
            "ALT, Tab, focuscurrentorlast"
            "CTRL ALT, Delete, exit"
          ]
          ++ workspaces;
        bindl = [
          ", XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioPlay,    exec, ${playerctl} play-pause"
          ",XF86AudioStop,    exec, ${playerctl} pause"
          ",XF86AudioPause,   exec, ${playerctl} pause"
          ",XF86AudioPrev,    exec, ${playerctl} previous"
          ",XF86AudioNext,    exec, ${playerctl} next"
        ];
        bindr = [
        ];
        bindel = [
          ", XF86AudioRaiseVolume, exec, ${wpctl} set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, ${wpctl} set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86MonBrightnessUp,   exec, ${brightnessctl} set +5%"
          ",XF86MonBrightnessDown, exec, ${brightnessctl} set  5%-"
        ];
        bindm = [
          "ALT,mouse:272,movewindow"
        ];
        monitor = [
          "HDMI-A-1,3840x2160,0x0,1"
          "DP-3,2560x1440,-2560x0,1"
          ",preferred,auto,1"
        ];
        windowrule = let
          f = regex: "float, ^(${regex})$";
        in [
          (f "org.gnome.Calculator")
          (f "org.gnome.Nautilus")
          (f "pavucontrol")
          (f "nm-connection-editor")
          (f "blueberry.py")
          (f "org.gnome.Settings")
          (f "org.gnome.design.Palette")
          (f "Color Picker")
          (f "xdg-desktop-portal")
          (f "xdg-desktop-portal-gnome")
          (f "transmission-gtk")
          (f "com.github.Aylur.ags")
          "workspace 7, title:Spotify"
        ];
        "debug:disable_logs" = "false";
        "misc:force_default_wallpaper" = 0;
      };
      wayland.windowManager.hyprland.extraConfig = ''
        # window resize
        bind = $mod, S, submap, resize

        submap = resize
        binde = , h, resizeactive, 10 0
        binde = , a, resizeactive, -10 0
        binde = , i, resizeactive, 0 -10
        binde = , e, resizeactive, 0 10
        bind = , escape, submap, reset
        submap = reset
      '';
    };
}
