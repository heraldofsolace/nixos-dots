_: {
  config,
  lib,
  pkgs,
  ...
}: let
  oh-my-tmux-conf = "oh-my-tmux.conf";
  oh-my-tmux-conf-path = "${config.xdg.configHome}/${oh-my-tmux-conf}";
  oh-tmux-conf-local = "${oh-my-tmux-conf}.local";
  oh-tmux-conf-local-path = "${config.xdg.configHome}/${oh-tmux-conf-local}";

  oh-my-tmux = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "oh-my-tmux";

    src = pkgs.fetchFromGitHub {
      owner = "gpakosz";
      repo = ".tmux";
      rev = "a795f9ec5167234c60f16a5390f199ec34833ea6";
      sha256 = "sha256-++AN5looD4yE/TBlAxCiJFbGXL+8v/+UsEvw+WddpCw=";
      stripRoot = false;
    };

    version = "a795f9ec5167234c60f16a5390f199ec34833ea6";

    nativeBuildInputs = [pkgs.gnused];

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out
      sed -e 's/$HOME\/.tmux.conf/${builtins.replaceStrings ["/"] ["\\/"] oh-my-tmux-conf-path}/g' .tmux-*/.tmux.conf > $out/.tmux.conf
    '';

    meta = with lib; {
      description = "Self-contained, pretty & versatile tmux configuration";
      homepage = "https://github.com/gpakosz/.tmux";
      license = licenses.gpl3Only;
    };
  };
in {
  home.packages = [pkgs.tmx];
  programs.tmux = {
    enable = true;

    clock24 = true;
    keyMode = "vi";
    shortcut = "b";
    terminal = "xterm-256color";

    plugins = with pkgs; [
      tmuxPlugins.cpu
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '10' # minutes
        '';
      }
    ];
    tmuxinator.enable = true;
    extraConfig = ''
      source-file "${oh-my-tmux-conf-path}";
    '';
  };

  # xdg.configFile."tmux/tmux.conf".text = "";
  # xdg.configFile."tmux/tmux.conf".source = "${oh-my-tmux}/.tmux.conf";

  xdg.configFile = {
    "${oh-my-tmux-conf}" = {
      source = "${oh-my-tmux}/.tmux.conf";
    };
    "${oh-tmux-conf-local}" = {
      source = ./_files/tmux.conf;
    };
  };
}
