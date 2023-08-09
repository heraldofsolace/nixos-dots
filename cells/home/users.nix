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
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA3GRcKkyXAJvKjyovyzkPzV9aaT7FRBSbnR1t1bmwqP"
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCrWDTKOYQ8HmWvmB8KI8rQBBIVsHdtFt0l3a3Y/D0Em+8sOTp86IFAi0RqFjlQabvaNGvYH2djCj57dnWQ5bOEF2EGbQ7dqON0i5RSKiIGpw+aSY58LueNK6Ht7dVGHMvRbDQMbLwxh8zbaxooVnLdG39zWSEKe8xS9fBw4Ym6E1Z8egcYYCGze2J+M3DOwj6/YIEpYOA1QQr60wPld6yfDsENdMk09G1uJp/ZI/Zz0a7DkCBtIQTz80yTvJSRCYDIfCNKqApa6NXTU9hqS7LoAxgAxb8jduO2b3JseRPhxGvS9wcuBIYRKZAOX5fmTVSqqFPox21gSn7yGGFJgiOeFZ3PCQXoimebRcTEiaffwcu7HE58ZT57ly5FVhQvJ6AIag2FjdExJqz5A6WYEaQFFPcJBZno2uaayGxzOYGzaCG6wbNR28HkvVf0wF2XiaHvtWCAAcYJ7f17cEtkCptYQQOnZ4tjFGaDmuKXRYFV4Kz79ceca9kYlY5bM3U+qyk= aniket@andromeda"
        ];
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
