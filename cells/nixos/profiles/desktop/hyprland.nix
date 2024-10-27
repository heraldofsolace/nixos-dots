{inputs, ...}: {
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [./common.nix];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };
  services.displayManager.sddm.enable = lib.mkForce false;
  security.pam.services.hyprlock = {};
  security.pam.services.ags = {};
  security.pam.services.greetd.enableKwallet = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
  environment.systemPackages = [
    inputs.hyprswitch.packages.x86_64-linux.default
  ];

  hardware.opengl = let
    pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in {
    package = pkgs-unstable.mesa.drivers;

    # if you also want 32-bit support (e.g for Steam)
    driSupport32Bit = true;
    package32 = pkgs-unstable.pkgsi686Linux.mesa.drivers;
    enable = true;
  };

  services.greetd = {
    enable = true;
    settings.default_session.command = "${pkgs.bashInteractive}/bin/bash -c 'sleep 2 && ${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/Hyprland'";
    settings.default_session.user = "aniket";
    # settings.default_session.command = pkgs.writeShellScript "greeter" ''
    #   export XKB_DEFAULT_LAYOUT=${config.services.xserver.xkb.layout}
    #   export XCURSOR_THEME=Qogir
    #   ${pkgs.aags}/bin/greeter
    # '';
  };
  services.atd.enable = true;
  services.atd.allowEveryone = true;

  systemd.tmpfiles.rules = [
    "d '/var/cache/greeter' - greeter greeter - -"
  ];
}
