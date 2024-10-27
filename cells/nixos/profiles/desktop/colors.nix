_: {pkgs, ...}: {
  stylix = {
    enable = true;
    image = ./_files/wall.png;
    polarity = "dark";
    base16Scheme = ./_files/tokyonight.yaml;
    fonts = {
      serif = {
        package = pkgs.nerdfonts;
        name = "Iosevka Serif";
      };

      sansSerif = {
        package = pkgs.nerdfonts;
        name = "Iosevka Sans";
      };

      monospace = {
        package = pkgs.nerdfonts;
        name = "JetBrains Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        desktop = 14;
        applications = 14;
      };
    };

    opacity = {
      popups = 0.5;
      applications = 0.5;
      desktop = 0.5;
      terminal = 0.8;
    };
  };
}
