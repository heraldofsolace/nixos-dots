pkgs: {
  plugin-bang-bang = pkgs.fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "plugin-bang-bang";
    rev = "f969c618301163273d0a03d002614d9a81952c1e";
    sha256 = "A8ydBX4LORk+nutjHurqNNWFmW6LIiBPQcxS3x4nbeQ=";
  };
  plugin-thefuck = pkgs.fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "plugin-thefuck";
    rev = "6c9a926d045dc404a11854a645917b368f78fc4d";
    sha256 = "9MbkyEsMsZH+3ct7qJSPvLeLRfVkDEkXRTdg/Rhe0dg=";
  };
  plugin-foreign-env = pkgs.fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "plugin-foreign-env";
    rev = "b3dd471bcc885b597c3922e4de836e06415e52dd";
    sha256 = "3h03WQrBZmTXZLkQh1oVyhv6zlyYsSDS7HTHr+7WjY8=";
  };
  plugin-gi = pkgs.fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "plugin-gi";
    rev = "48bc41a86c5dcf14ffe3745a7f61cba728a4de0c";
    sha256 = "njrOCUaWVj+CIZTUzRGrG4yxcEONEl2fpYuXZrAd4qg=";
  };
  fish-ssh-agent = pkgs.fetchFromGitHub {
    owner = "danhper";
    repo = "fish-ssh-agent";
    rev = "fd70a2afdd03caf9bf609746bf6b993b9e83be57";
    sha256 = "e94Sd1GSUAxwLVVo5yR6msq0jZLOn2m+JZJ6mvwQdLs=";
  };
}
