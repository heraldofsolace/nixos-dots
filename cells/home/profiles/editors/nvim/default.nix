{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withRuby = true;
    withPython3 = true;
    extraPython3Packages = ps:
      with ps; [
        setuptools
      ];
    extraConfig = ''
      lua require('start')
    '';
  };

  xdg.configFile."nvim" = {
    source = ./_nvim-config;
    recursive = true;
  };
}
