{
  inputs,
  common,
}: {
  lib,
  pkgs,
  config,
  self,
  ...
}: let
  inherit (lib) fileContents;
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in {
  imports = [
    common.core
    common.cachix
    inputs.home.nixosModules.default
    inputs.cells.tailscale.nixosModules.tailscale
    inputs.impermanence.nixosModules.impermanence
  ];

  #region nix options
  nix = {
    gc.automatic = true;
    settings = {
      sandbox = true;
      # Improve nix store disk usage
      auto-optimise-store = true;
      allowed-users = ["root @wheel"];

      # This is just a representation of the nix default
      system-features = ["nixos-test" "benchmark" "big-parallel" "kvm"];
    };

    optimise.automatic = true;
    extraOptions = ''
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
    '';
  };
  #endregion

  environment = {
    # Tools that I use everywhere
    systemPackages = with pkgs; [
      dosfstools
      gptfdisk
      iputils
      usbutils
      utillinux
      hexdump
      pciutils
      bc
      binutils
      coreutils
      curl
      cryfs
      direnv
      dnsutils
      fd
      git
      bottom
      jq
      manix
      moreutils
      nix-index
      nmap
      ripgrep
      skim
      tealdeer
      whois
      vim
      openalSoft
      comma
      vlc
      kdenlive
      mediainfo
      ffmpeg-full
      audacity
      xsane
      dosfstools
      gptfdisk
      usbutils
      wine
      winetricks
      obsidian
    ];
    shells = [pkgs.fish];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.verbose = true;

  fonts.packages = with pkgs; [
    nerdfonts
    powerline-fonts
    dejavu_fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    source-han-sans
    source-han-serif
    lohit-fonts.bengali
  ];

  #region Common system defaults
  time.timeZone = "Asia/Kolkata";

  users.mutableUsers = lib.mkDefault false;
  security.sudo.enable = lib.mkForce true;
  security.sudo.wheelNeedsPassword = lib.mkForce false;

  console = {
    font = "Lat2-Terminus16";
  };

  fonts.fontconfig.defaultFonts = {
    monospace = ["FiraCode Nerd Font Mono"];
    sansSerif = ["DejaVu Sans"];
  };

  programs.bash = {
    # Enable starship
    promptInit = ''
      eval "$(${pkgs.starship}/bin/starship init bash)"
    '';
    # Enable direnv, a tool for managing shell environments
    interactiveShellInit = ''
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"
    '';
  };

  programs.fuse = {
    userAllowOther = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  #endregion

  services.openssh = {
    enable = lib.mkDefault true;

    settings = {
      # Use only public keys
      PasswordAuthentication = lib.mkForce false;
      KbdInteractiveAuthentication = lib.mkForce false;

      # root login is never welcome, except for remote builders
      PermitRootLogin = lib.mkForce "prohibit-password";
    };

    startWhenNeeded = lib.mkDefault true;
    openFirewall = lib.mkDefault false;
  };

  # Service that makes Out of Memory Killer more effective
  services.earlyoom.enable = true;
}
