_: {pkgs, lib, ...}: {
    home.packages = with pkgs; [
      wally-cli
      via
      vial
      bazecor
      kanata
  ];


# [Unit]
# Description=Kanata keyboard remapper
# Documentation=https://github.com/jtroo/kanata

# [Service]
# Environment=PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin
# Environment=DISPLAY=:0
# Environment=HOME=/path/to/home/folder
# Type=simple
# ExecStart=/usr/local/bin/kanata --cfg /path/to/kanata/config/file
# Restart=never

# [Install]
# WantedBy=default.target
  systemd.user.services.kanata = let configFile = pkgs.writeText "kanata.cfg" (builtins.readFile ./_files/kanata.kbd); in
  {
    Unit = {
      Description = "Kanata keyboard remapper";
      Documentation = "https://github.com/jtroo/kanata";
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.kanata}/bin/kanata --cfg ${configFile}";
      Restart = "no";
      Environment = [
        "PATH=${lib.makeBinPath [ pkgs.coreutils pkgs.kanata ]}"
        "DISPLAY=:0"
      ];
    };
  };
}
