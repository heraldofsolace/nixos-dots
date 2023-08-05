{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs std haumea;
  l = nixpkgs.lib // builtins;
  userProfiles = cell.userProfiles;
  homeModules = cell.homeModules;
  modulesImportables = l.attrValues homeModules;
in {
  nixos = {
    aniket = {
      pkgs,
      config,
      ...
    }: {
      home-manager.users.aniket = _: {
        imports = with userProfiles;
          [workstation gui] ++ modulesImportables;
        programs.git.extraConfig = {
          extraConfig = {
            pull.rebase = false;
            user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA3GRcKkyXAJvKjyovyzkPzV9aaT7FRBSbnR1t1bmwqP";
            gpg.format = "ssh";
            "gpg \"ssh\"".program = "${pkgs._1password-gui}/share/1password/op-ssh-sign";
            commit.gpgsign = true;
          };
        };

        home.stateVersion = "23.05";
      };

      users.users.aniket = {
        passwordFile = config.sops.secrets.aniket-password.path;
        description = "Aniket Bhattacharyea";
        isNormalUser = true;
        uid = 1000;
        extraGroups = ["wheel" "docker" "networkmanager" "plugdev" "i2c" "vboxusers" "scanner" "lp"];
        shell = pkgs.bash; # bash as default shell to keep myself sane. In interactive mode, bash drops into fish
      };
    };

    hass = {
      pkgs,
      config,
      ...
    }: {
      users.users.hass = {
        passwordFile = config.sops.secrets.hass-password.path;
        description = "Home Assistant User";
        isNormalUser = true;
      };

      security.sudo.configFile = ''
        hass ALL=NOPASSWD:${pkgs.systemd}/bin/systemctl suspend
      '';
    };

    root = {config, ...}: {
      users.users.root = {
        uid = 0;
        # passwordFile = config.sops.secrets.root-password.path;
        hashedPassword = "$6$z0zrqUB8GGXrbGo/$JEeOmM3VRn3zs9cuOXOzl5eU1YQlt1xaSqtv33cftqIsgK0MZQYET8a.oiGuWY9d32t5CX4CB3bNQNDUHmHQj0";
      };
    };
  };
}
