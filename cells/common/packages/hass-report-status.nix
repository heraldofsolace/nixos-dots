{writeShellApplication, ...}:
writeShellApplication {
  name = "hass-report-status";
  text = ''
    curl --header "Content-Type: application/json" --request POST --data "{\"in_use\": \"$2\"}" "$1"
  '';
}
