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
      shell.eza
      shell.bat
      shell.gpg
      editors.nvim
      home-manager-base
      ssh
    ];

    education = [
      education
    ];

    shell-extras = with shell; [
      bat
      cli
      eww
      gpg
      jq
      mcfly
      thefuck
      zoxide
      less
      navi
      nushell
      pywal
      # sagemath
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
      dev.ruby
    ];

    develop-gui = [
      editors.vscode
      editors.ides.jetbrains
      editors.emacs
    ];

    develop-server = [
      editors.vscode-server
    ];

    keyboards = [misc.keyboard];
    android = [dev.android];

    gui-apps = [
      browsers.firefox
      browsers.brave
      comms.chat
      desktop.kdeconnect
      desktop.theme
      misc.join
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

    audio = [
      audio
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
        education
        audio
        keyboards
        inputs.aniVim.homeModule
      ];
  };
  minimal = {...}: {
    imports = with suites;
      l.flatten [
        base
        inputs.aniVim.homeModule
      ];
  };
  server-dev = {...}: {
    imports = with suites;
      l.flatten [
        develop
        develop-langs
        develop-server
        inputs.nixos-vscode-server.homeModules.default
      ];
  };
  vscode-server = {...}: {
    imports = with suites;
      l.flatten [
        develop-server
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
        # inputs.stylix.homeManagerModules.stylix
      ];
  };
}
