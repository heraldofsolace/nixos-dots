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
    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.hyprland;
    };

    weztermPackage = lib.mkOption {
      type = lib.types.package;
      default = pkgs.wezterm;
    };

    hyprlockPackage = lib.mkOption {
      type = lib.types.package;
      default = pkgs.hyprlock;
    };

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
        fzf
      ];

      programs.${terminal}.enable = true;
      programs.hyprland-suite.wezterm.enable = cfg.enableWezterm;
      programs.hyprland-suite.wezterm.package = cfg.weztermPackage;
      programs.hyprland-suite.waybar.enable = cfg.enableWaybar;
      programs.hyprland-suite.rofi.enable = cfg.enableRofi;
      programs.hyprland-suite.hyprshade.enable = cfg.enableHyprshade;
      programs.hyprland-suite.hyprlock.enable = cfg.enableHyprlock;
      programs.hyprland-suite.hyprlock.package = cfg.hyprlockPackage;
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
      wayland.windowManager.hyprland.plugins = cfg.plugins;
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
        wallpaper-day = ./_files/wall.png;
        wallpaper-evening = ./_files/wallpaper-evening.gif;
        wallpaper-night = ./_files/wall2.png;
        red = config.lib.stylix.colors.base0F;
        mauve = config.lib.stylix.colors.base0E;
        teal = config.lib.stylix.colors.base0D;
        sapphire = config.lib.stylix.colors.base0C;
        green = config.lib.stylix.colors.base0B;
        lavender = config.lib.stylix.colors.base08;
        blue = config.lib.stylix.colors.base0A;
      in {
        "$mod" = "SUPER";
        exec-once =
          [
            "swww-daemon"
            "swww-schedule -i \"${wallpaper-day};05:00\" -i \"${wallpaper-night};17:00\""
            "${pkgs.kwallet-pam}/libexec/pam_kwallet_init"
            "/nix/store/$(ls -la /nix/store | grep polkit-kde-agent | grep '^d' | awk '{print $9}')/libexec/polkit-kde-authentication-agent-1"
            "hyprswitch init --show-title &"
          ]
          ++ (
            if cfg.enableAGS
            then ["hyprpanel"]
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
            "windows, 1, 8, md3_decel, slide top"
            "windowsIn, 1, 8, md3_standard, slide top 0%"
            "windowsOut, 1, 8, md3_standard, slide top 0%"
            "windowsMove, 1, 8, md3_standard, slide top 20%"
            "layersIn, 1, 4, menu_accel, slide top 20%"
            "layersOut, 1, 4, menu_decel, slide top 20%"
            "fadeIn, 1, 8, default"
            "fadeOut, 1, 8, default"
            "fadeSwitch, 1, 8, default"
            "fadeShadow, 1, 8, default"
            "fadeDim, 1, 8, default"
            "fadeLayersIn, 1, 8, default"
            "fadeLayersOut, 1, 8, default"
            "border, 1, 6, linear"
            "borderangle, 1, 100, linear, loop"
            #animation = borderangle, 1, 30, linear, once
            "fadeIn, 1, 10, default"
            "workspaces, 1, 8, default, slidevert"
            #animation = workspaces, 1, 5, wind
          ];
          bezier = [
            "linear, 0.0, 0.0, 1.0, 1.0"
            "md3_standard, 0.2, 0, 0, 1"
            "md3_decel, 0.05, 0.7, 0.1, 1"
            "md3_accel, 0.3, 0, 0.8, 0.15"
            "overshot, 0.05, 0.9, 0.1, 1.1"
            "crazyshot, 0.1, 1.5, 0.76, 0.92"
            "hyprnostretch, 0.05, 0.9, 0.1, 1.1"
            "menu_decel, 0.1, 1, 0, 1"
            "menu_accel, 0.38, 0.04, 1, 0.07"
            "easeOutBack, 0.34, 1.3, 0.64, 1"
            "easeOutExpo, 0.16, 1, 0.3, 1"
            "popIn, 0.05, 0.9, 0.1, 1.05"
            "softAcDecel, 0.26, 0.26, 0.15, 1"
            "md2, 0.4, 0, 0.2, 1"
          ];
        };

        misc = {
          vrr = 0;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          force_default_wallpaper = 0;
        };

        decoration = {
          rounding = 20;
          drop_shadow = true;
          shadow_offset = "0, 0";
          shadow_range = 30;
          shadow_render_power = 3;
          "col.shadow" = "0x66000000";
          inactive_opacity = 0.6;
          active_opacity = 0.9;
          blur = {
            enabled = true;
            size = 15;
            passes = 4;
            ignore_opacity = true;
            new_optimizations = true;
            xray = false;
            brightness = 1;
            noise = 0.01;
            contrast = 1;
            popups = true;
            popups_ignorealpha = 0.6;
          };
        };

        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 4;
          "col.active_border" = "rgb(${lavender}) rgb(${mauve}) rgb(${red}) rgb(${teal}) rgb(${sapphire}) rgb(${green}) rgb(${blue}) 45deg";
          "col.inactive_border" = "rgba(00000000)";
          layout = "dwindle";
          resize_on_border = true;
        };

        plugin = {
          borders-plus-plus = {
            add_borders = 1;
            "col.border_1" = "rgb(000000)";
            border_size_1 = 5;
          };
        };

        group = {
          "col.border_active" = "rgb(${mauve}) rgb(${red}) rgb(${blue}) 45deg";
          "col.border_inactive" = "rgb(${green}) rgb(${mauve}) 45deg";
          "col.border_locked_active" = "rgb(${mauve}) rgb(${blue}) 45deg";
          "col.border_locked_inactive" = "rgb(${green}) rgb(${mauve}) 45deg";
          groupbar = {
            font_size = 10;
            text_color = "rgb(${config.lib.stylix.colors.base05})";
          };
        };

        windowrulev2 = [
          "center, title:^(Keybindings)$"
          "center, class:^(system-monitoring-center)$"
          "float, class:^(system-monitoring-center)$"
          "size 1800 1000, class:^(system-monitoring-center)$"
          "idleinhibit fullscreen, class:^(*)$"
          "idleinhibit fullscreen, title:^(*)$"
          "idleinhibit fullscreen, fullscreen:1"

          "float, class:^([Ss]potify|[Ww]aypaper|Dolphin|[Ww]aypaper-engine)$"
          "center, class:^([Ss]potify|[Ww]aypaper|Dolphin|[Ww]aypaper-engine)$"
          "size 1800 1000, class:^([Ss]potify|[Ww]aypaper|Dolphin|[Ww]aypape-engine)$"
          "float, title:Thunar"
          "center, title:Thunar"
          "size 1800 1000, title:Thunar"
          "float, class:^(.*com.github.Aylur.ags*)$"
          "center, class:^(.*com.github.Aylur.ags*)$"
          "size 1800 1000, class:^(.*com.github.Aylur.ags*)$"
          "float, title:Dolphin"
          "center, title:Dolphin"
          "size 1800 1000, title:Dolphin"

          "float, class:^(org.kde.polkit-kde-authentication-agent-1)$"
          "float, class:([Zz]oom|onedriver|onedriver-launcher)$"
          "float, class:([Tt]hunar), title:(File Operation Progress)"
          "float, class:([Tt]hunar), title:(Confirm to replace files)"
          "float, class:(xdg-desktop-portal-gtk)"
          "float, class:(org.gnome.Calculator), title:(Calculator)"
          "float, class:(codium|codium-url-handler|VSCodium|code-oss), title:(Add Folder to Workspace)"
          "float, class:(electron), title:(Add Folder to Workspace)"
          "float, class:^(nm-applet|nm-connection-editor|blueman-manager)$"
          "float, class:^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$ " # system monitor
          "float, title:(Kvantum Manager)"
          "float, class:^([Ss]team)$,title:^((?![Ss]team).*|[Ss]team [Ss]ettings)$"
          "float, class:^([Qq]alculate-gtk)$"
          "float, title:^(Picture-in-Picture)$"
          # float, title:^(Firefox)$

          # windowrule v2 - opacity #enable as desired
          "opacity 0.8 0.6, class:^([Ss]potify|[Vv]esktop|[Dd]iscord)$"
          "opacity 0.9 0.7, class:^(Brave-browser(-beta|-dev)?)$"
          "opacity 0.9 0.7, class:^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr)$"
          "opacity 0.9 0.8, class:^(google-chrome(-beta|-dev|-unstable)?)$"
          "opacity 0.94 0.86, class:^(chrome-.+-Default)$ " # Chrome PWAs
          "opacity 0.9 0.8, class:^([Tt]hunar|org.gnome.Nautilus)$"
          "opacity 0.9 0.8, class:^(deluge)$"
          "opacity 0.8 0.7, class:^(Alacritty|kitty|kitty-dropterm)$" # Terminals
          "opacity 0.9 0.7, class:^(VSCodium|codium-url-handler|code-oss)$"
          "opacity 0.9 0.8, class:^(nwg-look|qt5ct|qt6ct|[Yy]ad)$"
          "opacity 0.9 0.8, title:(Kvantum Manager)"
          "opacity 0.9 0.7, class:^(com.obsproject.Studio)$"
          "opacity 0.9 0.7, class:^([Aa]udacious)$"
          "opacity 0.9 0.8, class:^(VSCode|code-url-handler)$"
          "opacity 0.9 0.8, class:^(jetbrains-.+)$" # JetBrains IDEs
          "opacity 0.94 0.86, class:^([Dd]iscord|[Vv]esktop)$"
          "opacity 0.9 0.8, class:^(org.telegram.desktop|io.github.tdesktop_x64.TDesktop)$"
          "opacity 0.82 0.75, class:^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$"
          "opacity 0.9 0.8, class:^(xdg-desktop-portal-gtk)$" # gnome-keyring gui
          "opacity 0.95 0.75, title:^(Picture-in-Picture)$"

          # windowrule v2 - size
          "size 70% 70%, class:^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$"
          "size 70% 70%, class:^(xdg-desktop-portal-gtk)$"
          "size 60% 70%, title:(Kvantum Manager)"

          # size 25% 25%, title:^(Picture-in-Picture)$
          # size 25% 25%, title:^(Firefox)$

          # windowrule v2 - pinning
          "pin,title:^(Picture-in-Picture)$"
          # pin,title:^(Firefox)$

          # windowrule v2 - extras
          "keepaspectratio, title:^(Picture-in-Picture)$"
        ];

        bind = let
          monocle = "dwindle:no_gaps_when_only";
          e = "exec, ${pkgs.hyprpanel}/bin/hyprpanel";
        in
          [
            "SUPER, Return, exec, ${terminal}"
            "SUPER ALT, Return, exec, firefox"
            "SUPER ALT, Q, ${e} -t powermenu"
            "SUPER ALT, R,  ${e} quit; ${pkgs.hyprpanel}/bin/hyprpanel"
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

        $key = TAB
        $modifier = ALT
        $modifier_release = ALT_L
        $reverse = SHIFT

        # allows repeated switching with same keypress that starts the submap
        binde = $modifier, $key, exec, hyprswitch gui --do-initial-execute
        bind = $modifier, $key, submap, switch

        # allows repeated switching with same keypress that starts the submap
        binde = $modifier $reverse, $key, exec, hyprswitch gui --do-initial-execute -r
        bind = $modifier $reverse, $key, submap, switch

        submap = switch
        # allow repeated window switching in submap (same keys as repeating while starting)
        binde = $modifier, $key, exec, hyprswitch gui
        binde = $modifier $reverse, $key, exec, hyprswitch gui -r

        # switch to specific window offset (TODO replace with a more dynamic solution)
        bind = $modifier, 1, exec, hyprswitch gui --offset=1
        bind = $modifier, 2, exec, hyprswitch gui --offset=2
        bind = $modifier, 3, exec, hyprswitch gui --offset=3
        bind = $modifier, 4, exec, hyprswitch gui --offset=4
        bind = $modifier, 5, exec, hyprswitch gui --offset=5

        bind = $modifier $reverse, 1, exec, hyprswitch gui --offset=1 -r
        bind = $modifier $reverse, 2, exec, hyprswitch gui --offset=2 -r
        bind = $modifier $reverse, 3, exec, hyprswitch gui --offset=3 -r
        bind = $modifier $reverse, 4, exec, hyprswitch gui --offset=4 -r
        bind = $modifier $reverse, 5, exec, hyprswitch gui --offset=5 -r


        # exit submap and stop hyprswitch
        bindrt = $modifier, $modifier_release, exec, hyprswitch close
        bindrt = $modifier, $modifier_release, submap, reset

        # if it somehow doesn't close on releasing $switch_release, escape can kill (doesnt switch)
        bindr = ,escape, exec, hyprswitch close --kill
        bindr = ,escape, submap, reset
        submap = reset
      '';
    };
}
