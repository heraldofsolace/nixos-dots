_: {
  pkgs,
  lib,
  config,
  ...
}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      ${pkgs.thefuck}/bin/thefuck --alias fuck | source
    '';
    shellAliases = {
      # nix
      nrb = "sudo nixos-rebuild";
      # systemd
      ctl = "systemctl";
      stl = "s systemctl";
      utl = "systemctl --user";
      ut = "systemctl --user start";
      un = "systemctl --user stop";
      up = "s systemctl start";
      dn = "s systemctl stop";
      jtl = "journalctl";

      # quick cd
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";

      # git
      g = "git";

      # grep
      grep = "rg";
      gi = "grep -i";

      # internet ip
      # TODO: explain this hard-coded IP address
      myip = "dig +short myip.opendns.com @208.67.222.222 2>&1";

      # nix
      n = "nix";
      np = "n profile";
      ni = "np install";
      nr = "np remove";
      ns = "n search --no-update-lock-file";
      nf = "n flake";
      nepl = "n repl '<nixpkgs>'";
      srch = "ns nixos";
      orch = "ns override";
      mn = ''
        manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | sk --preview="manix '{}'" | xargs manix
      '';
      top = "btm";

      # sudo
      s = "sudo -E ";
      si = "sudo -i";
      se = "sudoedit";

      # bat
      cat = "bat --style header --style snip --style changes";
    };

    plugins = with import ./_files/fishPlugins/generated.nix pkgs; [
      {
        name = "bang-bang";
        src = plugin-bang-bang;
      }
      {
        name = "gi";
        src = plugin-gi;
      }
      {
        name = "foreign-env";
        src = plugin-foreign-env;
      }
      {
        name = "thefuck";
        src = plugin-thefuck;
      }
    ];
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.bash.bashrcExtra = ''
    if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    then
            exec fish
    fi
  '';
}
