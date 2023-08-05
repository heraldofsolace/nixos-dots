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
      shell.fish
      shell.tmux
      shell.exa
      shell.bat
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
    ];

    develop = [
      dev.aws
      dev.k8s
      dev.terraform
    ];

    develop-langs = [
      dev.nix
      dev.cc
      dev.python
      dev.node
      dev.rust
    ];

    develop-gui = [
      editors.vscode
      editors.ides.jetbrains
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
