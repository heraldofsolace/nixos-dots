_: {pkgs, ...}: {
  home.packages = with pkgs;
    [
      wget
      unzip
      git
      atool
      unrar
      gnupg
      pstree
      git-crypt
      nix-prefetch-scripts
      nixpkgs-review
      nixpkgs-fmt
      unrar
      gnumake
      zip
      nmap
      rclone
      wmctrl
      imagemagick
      gitAndTools.hub
      xclip
      just
    ]
    ++ lib.optionals (pkgs.system != "aarch64-linux") [
      universal-ctags
      ctagsWrapped.ctagsWrapped
    ];

  programs.command-not-found = {
    enable = true;
  };

  programs.zathura = {
    enable = true;
  };
}
