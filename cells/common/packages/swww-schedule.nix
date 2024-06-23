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
    IFS=$'\n' t="$(sort -t# -k2 <<<"''${images[*]}")"
    sorted=()
    while IFS="" read -r line; do sorted+=("$line"); done < <(echo "$t")
    unset IFS

    curr=$(date +%H:%M)
    for val in "''${!sorted[@]}"; do
      this=$(echo "''${sorted[val]}" | cut -d# -f2)
      img=$(echo "''${sorted[val]}" | cut -d# -f1)

      echo "swww img $img" | at "$this"
      next=$(echo "''${sorted[$((val + 1))]}" | cut -d# -f2)
      if [[ ! "$curr" < "$this" ]] && [[ "$curr" < "$next" ]];
      then
        echo "''${sorted[val]} will be used"

        swww img "$img"
        break
      fi
    done

    # curr = $(date +%H:%M)
    # if [[ "$curr" > "$day" && "$curr" < "$night" ]]; then
    #   echo "day"
    # else
    #   echo "night"
    # fi
    # echo "swww img $1" | at "$2"
  '';
}
