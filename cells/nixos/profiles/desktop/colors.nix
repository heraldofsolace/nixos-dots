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
      applications = 0.8;
      desktop = 0.8;
      terminal = 0.8;
    };

    cursor = {
      package = pkgs.runCommand "moveUp" {} ''
        mkdir -p $out/share/icons
        ln -s ${pkgs.fetchzip {
          url = "https://github.com/ful1e5/fuchsia-cursor/releases/download/v2.0.0/Fuchsia-Pop.tar.gz";
          hash = "sha256-BvVE9qupMjw7JRqFUj1J0a4ys6kc9fOLBPx2bGaapTk=";
        }} $out/share/icons/Fuchsia-Pop
      '';
      name = "Fuchsia-Pop";
      size = 32;
    };
  };
}
