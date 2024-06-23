{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.hyprland-suite.rofi;
in {
  options.programs.hyprland-suite.rofi = {
    enable = lib.mkEnableOption "Enable Rofi";
  };

  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      plugins = [
        (pkgs.rofi-calc.override {
          rofi-unwrapped = pkgs.rofi-wayland-unwrapped;
        })
        (pkgs.rofi-emoji.override {
          rofi-unwrapped = pkgs.rofi-wayland-unwrapped;
        })
      ];
      theme = let
        inherit (config.lib.formats.rasi) mkLiteral;
        mkRgba = opacity: color: let
          c = config.lib.stylix.colors;
          r = c."${color}-rgb-r";
          g = c."${color}-rgb-g";
          b = c."${color}-rgb-b";
        in
          mkLiteral
          "rgba ( ${r}, ${g}, ${b}, ${opacity} % )";
        mkRgb = mkRgba "100";
      in {
        "*" = {
          background = lib.mkForce (mkRgba "20" "base00");
          selected-normal-background = lib.mkForce (mkRgba "20" "base06");
          selected-normal-foreground = lib.mkForce (mkLiteral "@red");
          alternate-normal-background = lib.mkForce (mkLiteral "@background");
          alternate-active-background = lib.mkForce (mkLiteral "@background");
          alternate-urgent-background = lib.mkForce (mkLiteral "@background");
        };
        "#window" = {
          transparency = "real";
          location = mkLiteral "center";
          anchor = mkLiteral "center";
          border-radius = mkLiteral "0px";
          border = mkLiteral "0px solid";
          border-color = mkLiteral "@selected-normal-foreground";
          fullscreen = true;
          width = mkLiteral "3840px";
          height = mkLiteral "2160px";
          enabled = true;
          margin = mkLiteral "0px";
          padding = mkLiteral "15px";
        };

        "#mainbox" = {
          border = mkLiteral "0px solid";
          border-radius = mkLiteral "0px";
          border-color = mkLiteral "@selected-normal-foreground";
          children = map mkLiteral [
            "inputbar"
            "message"
            "listview"
            "mode-switcher"
          ];
          spacing = mkLiteral "100px";
          padding = mkLiteral "100px";
          background-color = mkLiteral "transparent";
        };

        "#textbox-prompt-colon" = {
          expand = false;
          enabled = true;
          str = "::";
          background-color = mkLiteral "transparent";
        };

        # Command prompt left of the input
        "#prompt" = {
          enabled = true;
          background-color = mkLiteral "transparent";
        };

        # Actual text box
        "#entry" = {
          enabled = true;
          background-color = mkLiteral "transparent";
          expand = true;

          placeholder = "";

          blink = true;
        };

        # Top bar
        "#inputbar" = {
          enabled = true;
          spacing = mkLiteral "10px";
          margin = mkLiteral "0% 28%";
          children = map mkLiteral [
            "prompt"
            "entry"
          ];
          border = mkLiteral "1px solid";
          border-radius = mkLiteral "6px";
          padding = mkLiteral "10px";
          background-color = mkLiteral "transparent";
        };

        # Results
        "#listview" = {
          enabled = true;
          padding = mkLiteral "0px";
          columns = 5;
          lines = 5;
          spacing = mkLiteral "0px";
          margin = mkLiteral "0px";
          border = mkLiteral "0px solid";
          border-radius = mkLiteral "0px";
          border-color = mkLiteral "@selected-normal-foreground";
          background-color = mkLiteral "transparent";
          cycle = true;
          dynamic = true;
          layout = mkLiteral "vertical";
          reverse = false;
          fixed-height = true;
          fixed-columns = true;
        };

        scrollbar = {
          handle-width = mkLiteral "5px";
          # handle-color = mkLiteral "@selected-normal-foreground";
          border-radius = mkLiteral "0px";
          background-color = mkLiteral "@lightbg";
        };

        # Each result
        "#element" = {
          orientation = mkLiteral "vertical";
          border-radius = mkLiteral "15px";
          spacing = mkLiteral "15px";
          margin = mkLiteral "0px";
          padding = mkLiteral "35px 10px";
          border = mkLiteral "0px solid";
          border-color = mkLiteral "@selected-normal-foreground";
          background-color = mkLiteral "transparent";
        };

        "#element-text" = {
          expand = true;
          horizontal-align = mkLiteral "0.5";
          vertical-align = mkLiteral "0.5";
          background-color = mkLiteral "transparent";
        };

        # Not sure how to get icons
        "#element-icon" = {
          size = mkLiteral "72px";
          border = mkLiteral "0px";
          background-color = mkLiteral "transparent";
        };

        mode-switcher = {
          background-color = mkLiteral "transparent";
        };
      };

      xoffset = 0;
      yoffset = -20;
      extraConfig = {
        show-icons = true;
        kb-cancel = "Escape,Super+space";
        modi = "window,drun,ssh,emoji,calc";
        sort = true;
        display-drun = "";
        drun-display-format = "{name}";
      };
    };
    home.packages = [pkgs.rofi-power-menu];
  };
}
