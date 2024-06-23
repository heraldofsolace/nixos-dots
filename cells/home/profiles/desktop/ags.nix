{inputs, ...}: {
  pkgs,
  config,
  ...
}: {
  home.packages = with config.lib.stylix.colors.withHashtag; [
    (pkgs.aags.override
      {
        colors = {
          dark = {
            primary = {
              bg = "${base0B}";
              fg = "${base01}";
            };
            error = {
              bg = "${base0F}";
              fg = "${base01}";
            };
            bg = "${base00}";
            fg = "${base06}";
            widget = "${base07}";
            border = "${base07}";
          };
          light = {
            primary = {
              bg = "#426ede";
              fg = "#eeeeee";
            };
            error = {
              bg = "#b13558";
              fg = "#eeeeee";
            };
            bg = "#fffffa";
            fg = "#080808";
            widget = "#080808";
            border = "#080808";
          };
        };
      })
  ];
}
