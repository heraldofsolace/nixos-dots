{
  writeShellApplication,
  writeText,
  ...
}:
writeShellApplication {
  name = "rofi-power-menu";
  text = let
    avatar = ./_files/avatar.png;
    theme = writeText "theme.rasi" ''
      /*****----- Configuration -----*****/
      configuration {
          show-icons:                 false;
      }

      *{
        bgcolor:                        #00000099;
      }

      /*****----- Global Properties -----*****/
      * {
          /* Resolution : 1920x1080 */
          mainbox-spacing:             50px;
          mainbox-margin:              0px 470px;
          message-margin:              0px 350px;
          message-padding:             15px;
          message-border-radius:       100%;
          listview-spacing:            25px;
          element-padding:             45px 40px;
          element-border-radius:       100%;

          prompt-font:                 "Iosevka Nerd Font Bold 32";
          textbox-font:                "Iosevka Nerd Font 12";
          element-text-font:           "feather Bold 48";

          /* Gradients */
          gradient-1:                  linear-gradient(45, #1E98FD, #06FDA5);
          gradient-2:                  linear-gradient(0, #F971C6, #7A72EC);
          gradient-3:                  linear-gradient(70, #FFD56F, #FF6861);
          gradient-4:                  linear-gradient(135, #44C6FA, #3043A1);
          gradient-5:                  linear-gradient(to left, #bdc3c7, #2c3e50);
          gradient-6:                  linear-gradient(to right, #0F2027, #203A43, #2C5364);
          gradient-7:                  linear-gradient(to top, #12c2e9, #c471ed, #f64f59);
          gradient-8:                  linear-gradient(to bottom, #FF0099, #493240);
          gradient-9:                  linear-gradient(0, #1a2a6c, #b21f1f, #fdbb2d);
          gradient-10:                 linear-gradient(0, #283c86, #45a247);
          gradient-11:                 linear-gradient(0, #77A1D3, #79CBCA, #E684AE);
          gradient-12:                 linear-gradient(0, #ff6e7f, #bfe9ff);
          gradient-13:                 linear-gradient(0, #D31027, #EA384D);
          gradient-14:                 linear-gradient(0, #DA22FF, #9733EE);
          gradient-15:                 linear-gradient(0, #1D976C, #93F9B9);
          gradient-16:                 linear-gradient(0, #232526, #414345);
          gradient-17:                 linear-gradient(0, #833ab4, #fd1d1d, #fcb045);
          gradient-18:                 linear-gradient(0, #667db6, #0082c8, #0082c8, #667db6);
          gradient-19:                 linear-gradient(0, #03001e, #7303c0, #ec38bc, #fdeff9);
          gradient-20:                 linear-gradient(0, #780206, #061161);

        /*background-window:           var(gradient-6);*/
          background-window:		@bgcolor;
          background-normal:           white/10%;
          background-selected:         white/20%;
          foreground-normal:           white;
          foreground-selected:         white;
      }

      /*****----- Main Window -----*****/
      window {
          transparency:                "real";
          location:                    center;
          anchor:                      center;
          fullscreen:                  true;
          cursor:                      "default";
        /*background-image:            var(background-window);*/
          background-color:		  @bgcolor;
      }

      /*****----- Main Box -----*****/
      mainbox {
          enabled:                     true;
          spacing:                     var(mainbox-spacing);
          margin:                      var(mainbox-margin);
          background-color:            transparent;
          children:                    [ "dummy", "userimage", "inputbar", "listview", "message", "dummy" ];
      }

      /*****----- User -----*****/
      userimage {
          margin:                      0px 400px;
          border:                      2px;
          border-radius:               100%;
          border-color:                #67b0e8;
          background-color:            transparent;
          background-image:            url("${avatar}", both);
      }

      /*****----- Inputbar -----*****/
      inputbar {
          enabled:                     true;
          background-color:            transparent;
          children:                    [ "dummy", "prompt", "dummy"];
      }

      dummy {
          background-color:            transparent;

      }

      prompt {
          enabled:                     true;
          font:                        var(prompt-font);
          background-color:            transparent;
          text-color:                  var(foreground-normal);
      }

      /*****----- Message -----*****/
      message {
          enabled:                     true;
          margin:                      var(message-margin);
          padding:                     var(message-padding);
          border-radius:               var(message-border-radius);
          background-color:            var(background-normal);
          text-color:                  #67b0e8;
      }
      textbox {
          font:                        var(textbox-font);
          background-color:            transparent;
          text-color:                  inherit;
          vertical-align:              0.5;
          horizontal-align:            0.5;
      }

      /*****----- Listview -----*****/
      listview {
          enabled:                     true;
          expand:                      false;
          columns:                     5;
          lines:                       1;
          cycle:                       true;
          dynamic:                     true;
          scrollbar:                   false;
          layout:                      vertical;
          reverse:                     false;
          fixed-height:                true;
          fixed-columns:               true;

          spacing:                     var(listview-spacing);
          background-color:            transparent;
          cursor:                      "default";
      }

      /*****----- Elements -----*****/
      element {
          enabled:                     true;
          padding:                     var(element-padding);
          border-radius:               var(element-border-radius);
          background-color:            var(background-normal);
          text-color:                  var(foreground-normal);
          cursor:                      pointer;
      }
      element-text {
          font:                        var(element-text-font);
          background-color:            transparent;
          text-color:                  inherit;
          cursor:                      inherit;
          vertical-align:              0.5;
          horizontal-align:            0.5;
      }
      element selected.normal {
          background-color:            #232a2d70;
          text-color:                  #ee5396;
      }
    '';
  in ''
    uptime="$(uptime-nixos | sed -e 's/up //g')"


    # Options
    shutdown='☠'
    reboot='↺'
    lock='🔒'
    suspend='⇇'
    logout='🚪'
    yes='👍'
    no='👎'

    # Rofi CMD
    rofi_cmd() {
      rofi -dmenu \
        -p "Goodbye $USER" \
        -mesg "Uptime: $uptime" \
        -theme ${theme}
    }

    # Confirmation CMD
    confirm_cmd() {
      rofi -dmenu \
        -p 'Confirmation' \
        -mesg 'Are you Sure?'
    }

    # Ask for confirmation
    confirm_exit() {
      echo -e "$yes\n$no" | confirm_cmd
    }

    # Pass variables to rofi dmenu
    run_rofi() {
      echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
    }

    # Execute Command
    run_cmd() {
      selected="$(confirm_exit)"
      if [[ "$selected" == "$yes" ]]; then
        if [[ $1 == '--shutdown' ]]; then
          systemctl poweroff
        elif [[ $1 == '--reboot' ]]; then
          systemctl reboot
        elif [[ $1 == '--suspend' ]]; then
          mpc -q pause
          amixer set Master mute
          systemctl suspend
        elif [[ $1 == '--logout' ]]; then
          hyprctl dispatch exit
        fi
      else
        exit 0
      fi
    }

    # Actions
    chosen="$(run_rofi)"
    case $chosen in
        "$shutdown")
        run_cmd --shutdown
            ;;
        "$reboot")
        run_cmd --reboot
            ;;
        "$lock")
        hyprlock
            ;;
        "$suspend")
        run_cmd --suspend
            ;;
        "$logout")
        run_cmd --logout
            ;;
    esac
  '';
}