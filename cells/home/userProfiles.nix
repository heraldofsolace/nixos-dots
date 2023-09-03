{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs std haumea;
  l = nixpkgs.lib // builtins;
  suites = with cell.homeProfiles; {
    base = [
      shell.direnv
      git
      shell.bash
      shell.fish
      shell.tmux
      shell.exa
      shell.bat
      shell.gpg
      editors.nvim
      home-manager-base
      ssh
    ];

    shell-extras = with shell; [
      bat
      cli
      gpg
      jq
      mcfly
      thefuck
      zoxide
      less
      navi
      nushell
      pywal
      sagemath
    ];

    develop = [
      dev.aws
      dev.k8s
      dev.terraform
      dev.build-systems
    ];

    develop-langs = [
      dev.nix
      dev.cc
      dev.python
      dev.node
      dev.rust
      dev.go
    ];

    develop-gui = [
      editors.vscode
      editors.ides.jetbrains
      editors.emacs
    ];

    android = [dev.android];

    gui-apps = [
      browsers.firefox
      browsers.brave
      comms.chat
      desktop.kdeconnect
    ];

    finance = [
      desktop.kmymoney
    ];

    office = [
      misc.nextcloud
      misc.tex
    ];

    system = [
      misc.xprintidle
    ];

    media = [
      misc.obs
    ];
  };
in {
  workstation = {...}: {
    imports = with suites;
      l.flatten [
        base
        develop
        develop-langs
        develop-gui
        android
        shell-extras
      ];
  };
  minimal = {...}: {imports = suites.base;};
  server-dev = {...}: {
    imports = with suites;
      l.flatten [
        develop
        inputs.nixos-vscode-server.homeModules.default
      ];
  };
  gui = {...}: {
    imports = with suites;
      l.flatten [
        gui-apps
        finance
        office
        system
        media
      ];
  };
}
