{
  inputs,
  cell,
}: let
  latest = import inputs.latest {
    inherit (inputs.nixpkgs) system;
    config.allowUnfree = true;
  };
in {
  inherit
    (latest)
    android-tools
    vscodium
    alejandra
    nil
    terraform
    terraform-ls
    kubelogin-oidc
    minikube
    kubernetes-helm
    nixpkgs-fmt
    statix
    # nix
    
    nix-diff
    act
    cachix
    nix-index
    _1password
    _1password-gui
    wrapHelm
    kubectl
    kubernetes-helmPlugins
    direnv
    nvfetcher
    amazon-ecr-credential-helper
    #
    
    tailscale
    ffmpeg_5-full
    earthly
    jetbrains
    siril
    obs-studio
    vial
    via
    wally-cli
    kanata
    fcitx5-openbangla-keyboard
    electron
    # kstars
    
    neovim
    wrapNeovimUnstable
    upower
    gamemode
    criterion
    power-profiles-daemon
    ;

  nanopb-generator-out = latest.nanopb-generator-out.overrideAttrs (oldAttrs: {
    patches =
      oldAttrs.patches
      ++ [
        ./_files/nanopb-generator-out.patch
      ];
  });
}
