_: {pkgs, ...}: {
  stylix.targets.waybar = {
    enable = true;
  };

  stylix.targets.tmux.enable = false;

  home.packages = with pkgs; [
    morewaita-icon-theme
    gnome.adwaita-icon-theme
    papirus-icon-theme
  ];
  gtk = {
    enable = true;
    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };
  };
}
