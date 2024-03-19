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
        ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-ssh-edit
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
          version = "0.8.11";
          sha256 = "sha256-XY439c8QtThw+d2zDDqfrlDi/+y+7+4i8lHbNEMwR3I=";
        }
        {
          name = "kotlin";
          publisher = "fwcd";
          version = "0.2.34";
          sha256 = "sha256-03F6cHIA9Tx8IHbVswA8B58tB8aGd2iQi1i5+1e1p4k=";
        }
        {
          name = "vscode-firefox-debug";
          publisher = "firefox-devtools";
          version = "2.9.10";
          sha256 = "sha256-xuvlE8L/qjOn8Qhkv9sutn/xRbwC9V/IIfEr4Ixm1vA=";
        }
        {
          name = "carbon";
          publisher = "whosydd";
          version = "0.4.0";
          sha256 = "sha256-hGZH6X8dLM8wS8dGlLxlUAppBdwo7DadGyQW7fVvuKI=";
        }
        {
          name = "vscode-icons";
          publisher = "vscode-icons-team";
          version = "12.7.0";
          sha256 = "sha256-q0PS5nSQNx/KUpl+n2ZLWtd3NHxGEJaUEUw4yEB7YPA=";
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
