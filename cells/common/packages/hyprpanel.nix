{
  inputs,
  pkgs,
  system,
  stdenv,
  lib,
  writeShellScript,
  bun,
  dart-sass,
  fd,
  fzf,
  accountsservice,
  btop,
  pipewire,
  bluez,
  bluez-tools,
  grimblast,
  gpu-screen-recorder,
  networkmanager,
  brightnessctl,
  cage,
  swww,
  python3,
  libgtop,
  gnome,
  gobject-introspection,
  glib,
  colors ? {
    dark = {
      primary = {
        bg = "#51a4e7";
        fg = "#141414";
      };
      error = {
        bg = "#e55f86";
        fg = "#141414";
      };
      bg = "#171717";
      fg = "#eeeeee";
      widget = "#eeeeee";
      border = "#eeeeee";
    };
    light = {
      primary = {
        bg = "#426ede";
        fg = "#eeeeee";
      };
      error = {
        bg = "#b13558";
        fg = "#eeeeee";
      };
      bg = "#fffffa";
      fg = "#080808";
      widget = "#080808";
      border = "#080808";
    };
  },
  ...
}: let
  inherit (inputs) ags matugen haumea;
  aags = ags.packages.${system}.default.override {
    extraPackages = [accountsservice];
  };

  pname = "hyprpanel";
  config = stdenv.mkDerivation {
    inherit pname;
    version = "latest";
    src = ./_hyprpanel-config;

    buildPhase = ''
      ${bun}/bin/bun build ./main.ts \
        --outfile main.js \
        --external "resource://*" \
        --external "gi://*"

      ${bun}/bin/bun build ./greeter/greeter.ts \
        --outfile greeter.js \
        --external "resource://*" \
        --external "gi://*"
    '';

    installPhase = ''
      mkdir $out
      cp -r assets $out
      cp -r scss $out
      cp -r widget $out
      cp -r greeter $out
      cp -r services $out
      cp -f main.js $out/config.js
      cp -f greeter.js $out/greeter.js
    '';
  };

  desktop = writeShellScript pname ''
    export PATH=$PATH:${lib.makeBinPath [dart-sass fd fzf btop pipewire bluez bluez-tools networkmanager matugen swww grimblast gpu-screen-recorder brightnessctl gnome.gnome-bluetooth python3]}
    export GI_TYPELIB_PATH=${libgtop}/lib/girepository-1.0:${glib}/lib/girepository-1.0:$GI_TYPELIB_PATH
    ${aags}/bin/ags -b hyprpanel -c ${config}/config.js $@
  '';

  greeter = writeShellScript "greeter" ''
    export PATH=$PATH:${lib.makeBinPath [dart-sass fd fzf btop pipewire bluez bluez-tools networkmanager matugen swww grimblast gpu-screen-recorder brightnessctl gnome.gnome-bluetooth python3]}
    ${cage}/bin/cage -ds -m last ${aags}/bin/ags -- -c ${config}/greeter.js
  '';
in
  stdenv.mkDerivation rec {
    inherit pname;
    name = pname;
    src = config;

    installPhase = ''
      mkdir -p $out/bin
      cp -r . $out
      cp ${desktop} $out/bin/${pname}
      cp ${greeter} $out/bin/greeter
    '';
  }
