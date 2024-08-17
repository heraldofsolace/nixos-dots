{
  description = "My NixOS dotfiles";

  nixConfig.extra-experimental-features = "nix-command flakes";
  nixConfig.extra-substituters = "https://nrdxp.cachix.org https://nix-community.cachix.org https://cache.lix.systems";
  nixConfig.extra-trusted-public-keys = "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o=";

  # common for deduplication
  inputs = {
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  # hive
  inputs = {
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixago = {
      url = "github:nix-community/nixago";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    std = {
      url = "github:divnix/std";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        devshell.follows = "devshell";
        nixago.follows = "nixago";
      };
    };

    haumea = {
      follows = "hive/std/haumea";
    };

    hive = {
      url = "github:divnix/hive";
      inputs = {
        nixago.follows = "nixago";
        nixpkgs.follows = "nixpkgs";
        colmena.follows = "colmena";
      };
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0-rc1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # tools
  inputs = {
    nix-filter.url = "github:numtide/nix-filter";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    colmena = {
      url = "github:zhaofengli/colmena";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    deploy = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvfetcher = {
      url = "github:berberman/nvfetcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    naersk = {
      url = "github:nmattia/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    comma = {
      url = "github:nix-community/comma";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    homeage = {
      url = "github:jordanisaacs/homeage";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };
    nur.url = "github:nix-community/NUR";
    stylix = {
      # url = "github:heraldofsolace/stylix";
      url = "git+file:///home/aniket/stylix";
    };
    aniVim.url = "github:heraldofsolace/aniVim";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    swww.url = "github:LGFae/swww";
    ags.url = "github:Aylur/ags";
    matugen.url = "github:InioX/matugen?ref=v2.2.0";
    asztal.url = "github:Aylur/dotfiles";
  };

  # nixpkgs & home-manager
  inputs = {
    latest.url = "github:NixOS/nixpkgs/nixos-unstable";
    k8s.url = "github:NixOS/nixpkgs/3005f20ce0aaa58169cdee57c8aa12e5f1b6e1b3";
    nixos.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs.follows = "nixos";

    home = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # tools
  inputs = {
    nixos-vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = {
    self,
    std,
    nixpkgs,
    hive,
    lix-module,
    ...
  } @ inputs:
    std.growOn {
      inherit inputs;

      nixpkgsConfig = {
        allowUnfree = true;
      };

      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      cellsFrom = ./cells;

      cellBlocks = with std.blockTypes;
      with hive.blockTypes; [
        (nixago "config")

        # Modules
        (functions "nixosModules")
        (functions "homeModules")

        # Profiles
        (functions "commonProfiles")
        (functions "nixosProfiles")
        (functions "homeProfiles")
        (functions "userProfiles")
        (functions "users")

        # Suites
        (functions "nixosSuites")
        (functions "homeSuites")

        (devshells "shells")

        (files "files")
        (installables "packages")
        (pkgs "overrides")
        (functions "overlays")

        colmenaConfigurations
        homeConfigurations
        nixosConfigurations
        darwinConfigurations
      ];
    }
    # soil
    {
      devShells = hive.harvest inputs.self ["repo" "shells"];
      packages = hive.harvest inputs.self [
        ["klipper" "packages"]
        ["common" "packages"]
        ["pam-reattach" "packages"]
        ["rpi" "packages"]
      ];

      nixosModules = hive.pick inputs.self [
        ["tailscale" "nixosModules"]
        ["klipper" "nixosModules"]
        ["k8s" "nixosModules"]
        ["stylix-shim" "nixosModules"]
      ];

      homeModules = hive.pick inputs.self [
        ["home" "homeModules"]
      ];
    }
    {
      colmenaHive = hive.collect self "colmenaConfigurations";
      nixosConfigurations = hive.collect self "nixosConfigurations";
      homeConfigurations = hive.collect self "homeConfigurations";
    }
    {
      debug = hive.harvest inputs.self ["repo" "debug"];
    };
}
