_: {
  pkgs,
  lib,
  config,
  ...
}: {
  services.jitsi-meet = {
    enable = true;
    hostName = "jitsi-meet.miranda.dorper-ghost.ts.net";
    videobridge.enable = true;
    jicofo.enable = true;
    jibri.enable = true;
    # jigasi.enable = true;
    nginx.enable = true;
    prosody.enable = true;
    excalidraw.enable = true;
    secureDomain.enable = true;
  };

  services.nginx.virtualHosts.${config.services.jitsi-meet.hostName} = {
    forceSSL = true;
    enableACME = false;
    listen.port = 480;
    sslCertificate = "/run/secrets/miranda-cert";
    sslCertificateKey = "/run/secrets/miranda-cert-key";
  };
}
