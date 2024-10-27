{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  packages = with pkgs; [
    (ags.overrideAttrs (old: {
      buildInputs = old.buildInputs ++ [pkgs.libdbusmenu-gtk3];
    }))
    accountsservice
    brightnessctl
    bun
    dart-sass
    fd
    fzf
    gtk3
    hyprpicker
    networkmanager
    pavucontrol
    slurp
    swww
    swappy
    wayshot
    wf-recorder
    wl-clipboard
    which
  ];
}
