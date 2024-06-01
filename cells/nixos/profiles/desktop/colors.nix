_: {pkgs, ...}: {
  stylix = {
    image = ./_files/wallpaper.jpg;
    polarity = "dark";

    fonts = {
      serif = {
        package = pkgs.nerdfonts;
        name = "Nerdfonts Serif";
      };

      sansSerif = {
        package = pkgs.nerdfonts;
        name = "Nerdfonts Sans";
      };

      monospace = {
        package = pkgs.nerdfonts;
        name = "Nerdfonts Sans Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
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
