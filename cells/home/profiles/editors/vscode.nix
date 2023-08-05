{
  inputs,
  cell,
}: {
  pkgs,
  lib,
  ...
}: let
  vs-exts = inputs.nix-vscode-extensions.extensions.vscode-marketplace;
in {
  programs.vscode = {
    enable = true;
    # TODO split extensions based on active modules
    extensions = with vs-exts;
      [
        github.copilot
        ms-python.python
        mikestead.dotenv
        ms-vscode.cpptools
        ms-pyright.pyright
        jnoortheen.nix-ide
        yzhang.markdown-all-in-one
        eamodio.gitlens
        ms-azuretools.vscode-docker
        github.vscode-pull-request-github
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "markdown-preview-enhanced";
          publisher = "shd101wyy";
          version = "0.6.3";
          sha256 = "742584450e6b1e79982ed625d76809f9d5cb9e932ee795a7985d557dd3f4c77e";
        }
        {
          name = "kotlin";
          publisher = "fwcd";
          version = "0.2.26";
          sha256 = "sha256-djo1m0myIpEqz/jGyaUS2OROGnafY7YOI5T1sEneIK8=";
        }
        {
          name = "vscode-firefox-debug";
          publisher = "firefox-devtools";
          version = "2.9.8";
          sha256 = "sha256-MCL562FPgEfhUM1KH5LMl7BblbjIkQ4UEwB67RlO5Mk=";
        }
        {
          name = "carbon";
          publisher = "whosydd";
          version = "0.3.4";
          sha256 = "sha256-+xu5pgAg8xW3hi4mdkIDGPy4lP5+zlYt6m7wF+AvRJw=";
        }
        {
          name = "vscode-icons";
          publisher = "vscode-icons-team";
          version = "11.20.0";
          sha256 = "sha256-wcSYTDMhqY2EgLmVVoXt9652THWxyPBpTI3GHfwYsQ4=";
        }
        {
          name = "better-comments";
          publisher = "aaron-bond";
          version = "3.0.2";
          sha256 = "sha256-hQmA8PWjf2Nd60v5EAuqqD8LIEu7slrNs8luc3ePgZc=";
        }
      ];
    userSettings = builtins.fromJSON (builtins.readFile ./_files/vscode-settings.json);
  };
}
