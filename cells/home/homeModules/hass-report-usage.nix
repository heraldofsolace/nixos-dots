{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.hass-report-usage;
in {
  options.services.hass-report-usage = {
    enable = lib.mkEnableOption "Enable hass-report-usage";

    url = lib.mkOption {
      type = lib.types.str;
      description = "URL to report to";
      example = "http://192.168.0.3:8123/api/webhook/eaea48a1-30e3-47bf-a076-30f816f0d3d1";
      default = "http://192.168.0.3:8123/api/webhook/eaea48a1-30e3-47bf-a076-30f816f0d3d1";
    };

    package = lib.mkPackageOption pkgs "hass-report-usage" {};
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.xdotool];
    systemd.user.services.hass-report-usage = {
      Unit = {
        Description = "Hass report usage";
      };

      Service = {
        Type = "simple";
        ExecStart = "${lib.getExe cfg.package} ${lib.escapeShellArg cfg.url}";
        Restart = "on-failure";
        RestartSec = 1;
      };

      Install.WantedBy = ["default.target"];
    };
  };
}
