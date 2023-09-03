{
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["aniket"];
  };
  programs.ssh.extraConfig = ''
      IdentityAgent ~/.1password/agent.sock
    '';
}
