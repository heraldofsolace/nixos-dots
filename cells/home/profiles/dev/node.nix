{
  inputs,
  cell,
}: {
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    nodejs_latest
    yarn
  ];

  # Run locally installed bin-script, e.g. n coffee file.coffee
  home.shellAliases = {
    noderun = ''PATH="$(${pkgs.nodejs_latest}/bin/npm bin):$PATH"'';
    ya = "yarn";
  };

  home.sessionVariables = {
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/config";
    NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
    NPM_CONFIG_TMP = "${config.xdg.stateHome}/npm";
    NPM_CONFIG_PREFIX = "${config.xdg.dataHome}/npm";
    NODE_REPL_HISTORY = "${config.xdg.cacheHome}/node/repl_history";
  };

  xdg.configFile."npm/config".text = ''
    cache=${config.xdg.configHome}/npm
    prefix=${config.xdg.dataHome}/npm
  '';
}
