_: {
  lib,
  pkgs,
  ...
}: {
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["aniket"];
  };
  # security.wrappers."1Password-KeyringHelper".source = lib.mkForce "${pkgs._1password-gui}/share/1password/1Password-BrowserSupport";
  programs.ssh.extraConfig = ''
    IdentityAgent ~/.1password/agent.sock
  '';
}
