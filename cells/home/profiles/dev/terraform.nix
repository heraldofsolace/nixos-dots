{
  inputs,
  cells,
}: {
  config,
  pkgs,
  ...
}: let
  inherit (inputs.cells.common) overrides;
in {
  programs.vscode.userSettings = {
    "[terraform]" = {
      "editor.defaultFormatter" = "hashicorp.terraform";
      "editor.formatOnSave" = true;
    };
    "terraform.experimentalFeatures.validateOnSave" = true;
    "terraform.experimentalFeatures.prefillRequiredFields" = true;
    "terraform.languageServer.path" = "${overrides.terraform-ls}/bin/terraform-ls";
    "terraform.languageServer.terraform.path" = "${overrides.terraform}/bin/terraform";
    "terraform.codelens.referenceCount" = true;
  };

  home.packages = with pkgs; [
    inputs.cells.common.packages.tfenv
    terragrunt
  ];

  home.file = {
    ".terraformrc" = let
      plugin-cache-dir = "${config.xdg.cacheHome}/terraform/plugin-cache";
    in {
      onChange = ''
        mkdir -p ${plugin-cache-dir}
      '';
      text = ''
        plugin_cache_dir = "${plugin-cache-dir}"
      '';
    };
  };
}
