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
  services.greetd = {
    enable = true;
    settings.default_session.command = pkgs.writeShellScript "greeter" ''
      export XKB_DEFAULT_LAYOUT=${config.services.xserver.xkb.layout}
      export XCURSOR_THEME=Qogir
      ${pkgs.aags}/bin/greeter
    '';
  };
  services.atd.enable = true;
  services.atd.allowEveryone = true;

  systemd.tmpfiles.rules = [
    "d '/var/cache/greeter' - greeter greeter - -"
  ];
}
