{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      IdentityAgent ~/.1password/agent.sock
    '';
    matchBlocks = {
      "rpi" = {
        hostname = "pi.hole";
        user = "pi";
      };
    };
  };

  # xdg.configFile."autostart/ssh-add.desktop".text = ''
  #   [Desktop Entry]
  #   Exec=ssh-add
  #   Name=ssh-add
  #   Type=Application
  #   X-KDE-AutostartScript=true
  # '';

  home.sessionVariables = {
    SSH_ASKPASS_REQUIRE = "prefer";
  };
}
