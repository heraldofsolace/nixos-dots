pkgs: {
  plugin-bang-bang = pkgs.fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "plugin-bang-bang";
    rev = "ec991b80ba7d4dda7a962167b036efc5c2d79419";
    hash = "sha256-oPPCtFN2DPuM//c48SXb4TrFRjJtccg0YPXcAo0Lxq0=";
  };
  plugin-thefuck = pkgs.fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "plugin-thefuck";
    rev = "6c9a926d045dc404a11854a645917b368f78fc4d";
    hash = "sha256-9MbkyEsMsZH+3ct7qJSPvLeLRfVkDEkXRTdg/Rhe0dg=";
  };
  plugin-foreign-env = pkgs.fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "plugin-foreign-env";
    rev = "7f0cf099ae1e1e4ab38f46350ed6757d54471de7";
    hash = "sha256-4+k5rSoxkTtYFh/lEjhRkVYa2S4KEzJ/IJbyJl+rJjQ=";
  };
  plugin-gi = pkgs.fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "plugin-gi";
    rev = "48bc41a86c5dcf14ffe3745a7f61cba728a4de0c";
    hash = "sha256-njrOCUaWVj+CIZTUzRGrG4yxcEONEl2fpYuXZrAd4qg=";
  };
  fish-ssh-agent = pkgs.fetchFromGitHub {
    owner = "danhper";
    repo = "fish-ssh-agent";
    rev = "fd70a2afdd03caf9bf609746bf6b993b9e83be57";
    hash = "sha256-e94Sd1GSUAxwLVVo5yR6msq0jZLOn2m+JZJ6mvwQdLs=";
  };
  fish-kill-on-port = pkgs.fetchFromGitHub {
    owner = "vincentjames501";
    repo = "fish-kill-on-port";
    rev = "eb91062e5f5356ef63c6fff77f54fd10c027378e";
    hash = "sha256-rJ/HJsMhQYcRwcbSOacFjJsZOGfP3A2p3sAOx0zIAXY=";
  };
}
