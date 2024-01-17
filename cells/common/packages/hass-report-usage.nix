{writeShellApplication, ...}:
writeShellApplication {
  name = "hass-report-usage";
  text = ''
      #!/usr/bin/env bash
      # Abort if another instance is already running.
      if [ -e /dev/shm/in_use.pid ]; then
        read -r PID < /dev/shm/in_use.pid
        if kill -0 "$PID" > /dev/null 2>&1; then
          echo >&2 "already running. aborting."
          exit 1
        fi
      fi

      trap 'rm /dev/shm/in_use; curl --header "Content-Type: application/json" --request POST --data "{\"in_use\": \"false\"}" "$1"' EXIT

      echo $$ > /dev/shm/in_use.pid

      # Initially set the status to idle.
      echo "false" > /dev/shm/in_use

      # Store a timestamp 10 minutes in the past, to trigger an immediate update.
      echo $(( $(date +%s%3N) - 600000)) > /dev/shm/in_use.timestamp

      # Consider computer idle after 3 minutes.
      TIMEOUT=180000

      while true; do
      if [ "$(xprintidle)" -lt $TIMEOUT ]; then
        IN_USE=true
      else
        IN_USE=false
      fi

      # Report every 3 minutes.
      if [ "$(date +%s%3N)" -gt $(( $(cat /dev/shm/in_use.timestamp) + TIMEOUT)) ]; then
        REPORT=true
      else
        REPORT=false
      fi

      if [ "$(cat /dev/shm/in_use)" != $IN_USE ]; then
        CHANGED=true
      else
        CHANGED=false
      fi

      if $REPORT || $CHANGED; then
        echo $IN_USE > /dev/shm/in_use
        date +%s%3N > /dev/shm/in_use.timestamp
        curl --header "Content-Type: application/json" --request POST --data '{"in_use": '$IN_USE'}' "$1"
      fi

      sleep 0.2
    done
  '';
}
