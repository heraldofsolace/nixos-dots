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
    rnix-lsp
    nil
    terraform
    terraform-ls
    kubelogin-oidc
    minikube
    kubernetes-helm
    nixpkgs-fmt
    statix
    nixUnstable
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
    ;
}
