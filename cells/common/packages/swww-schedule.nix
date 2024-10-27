{writeShellApplication, ...}:
writeShellApplication {
  name = "swww-schedule";
  text = ''
    while getopts "i:" opt; do
      case $opt in
        i)
          images+=("$OPTARG")
          ;;
        *) exit 1;;
      esac
    done
    shift $((OPTIND - 1))
    IFS=$'\n' t="$(sort -t';' -k2 <<<"''${images[*]}")"
    sorted=()
    while IFS="" read -r line; do sorted+=("$line"); done < <(echo "$t")
    unset IFS

    found=0
    curr=$(date +%H:%M)
    for val in "''${!sorted[@]}"; do
      this=$(echo "''${sorted[val]}" | cut -d';' -f2)
      img=$(echo "''${sorted[val]}" | cut -d';' -f1)

      echo "swww img $img --transition-type center" | at "$this"
    done

    for val in "''${!sorted[@]}"; do
      this=$(echo "''${sorted[val]}" | cut -d';' -f2)
      img=$(echo "''${sorted[val]}" | cut -d';' -f1)

      if [[ $val -eq $((''${#sorted[@]} - 1)) ]]; then
        echo "Last element"
        break
      fi
      next=$(echo "''${sorted[$((val + 1))]}" | cut -d';' -f2)
      if [[ ! "$curr" < "$this" ]] && [[ "$curr" < "$next" ]];
      then
        echo "''${sorted[val]} will be used"
        found=1
        swww img "$img" --transition-type center
        break
      fi
    done

    if [[ $found -eq 0 ]]; then
      echo "$curr not found in array"

      # Either before the first or after the last
      if [[ "$curr" < "$(echo "''${sorted[0]}" | cut -d';' -f2)" ]]; then
        echo "Before the first"
        img=$(echo "''${sorted[0]}" | cut -d';' -f1)
        echo "Setting $img"
        swww img "$img" --transition-type center
      else
        echo "After the last"
        img=$(echo "''${sorted[-1]}" | cut -d';' -f1)
        echo "Setting $img"
        swww img "$img" --transition-type center
      fi
    fi
  '';
}
