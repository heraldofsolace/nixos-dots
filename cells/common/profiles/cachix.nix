{
  nix.settings = {
    substituters = [
      "https://cache.nixos.org/"

      "https://cuda-maintainers.cachix.org"
      "https://mic92.cachix.org"
      "https://nix-community.cachix.org"
      "https://nrdxp.cachix.org"
      "https://heraldofsolace.cachix.org"
    ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "mic92.cachix.org-1:gi8IhgiT3CYZnJsaW7fxznzTkMUOn1RY4GmXdT/nXYQ="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
      "heraldofsolace.cachix.org-1:9lDlToY337Al15dD5qga1RUkc98rhYKlFhPxxaD4I+s="
    ];
  };
}
