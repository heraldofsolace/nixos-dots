{
  writeShellScript,
  system,
  stdenv,
  cage,
  swww,
  esbuild,
  dart-sass,
  fd,
  fzf,
  brightnessctl,
  accountsservice,
  wf-recorder,
  wl-clipboard,
  grimblast,
  swappy,
  hyprpicker,
  pavucontrol,
  networkmanager,
  gtk3,
  which,
  inputs,
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
  name = "aags";
  l = inputs.nixpkgs.lib // builtins;
  aags = ags.packages.${system}.default.override {
    extraPackages = [accountsservice];
  };

  dependencies = [
    which
    dart-sass
    fd
    fzf
    brightnessctl
    swww
    matugen
    wf-recorder
    wl-clipboard
    grimblast
    swappy
    hyprpicker
    pavucontrol
    networkmanager
    gtk3
  ];

  addBins = list: builtins.concatStringsSep ":" (builtins.map (p: "${p}/bin") list);
  flattenSet = att:
    l.flatten (map (at:
      if builtins.isAttrs att.${at}
      then (map (p: "${at}.${p}") (flattenSet att.${at}))
      else at) (builtins.attrNames att));

  colorsFlattened = flattenSet colors;
  substituteColors = fcol: builtins.concatStringsSep ";" (map (p: "substituteInPlace ./options.ts --replace '${p}' '${(l.getAttrFromPath (l.splitString "." p) colors)}'") fcol);

  greeter = writeShellScript "greeter" ''
    export PATH=$PATH:${addBins dependencies}
    ${cage}/bin/cage -ds -m last ${aags}/bin/ags -- -c ${config}/greeter.js
  '';

  desktop = writeShellScript name ''
    export PATH=$PATH:${addBins dependencies}
    ${aags}/bin/ags -b ${name} -c ${config}/config.js $@
  '';

  config = stdenv.mkDerivation {
    inherit name;
    src = ./_aags-config;

    buildPhase = ''
      ${substituteColors colorsFlattened}

      ${esbuild}/bin/esbuild \
        --bundle ./main.ts \
        --outfile=main.js \
        --format=esm \
        --external:resource://\* \
        --external:gi://\* \

      ${esbuild}/bin/esbuild \
        --bundle ./greeter/greeter.ts \
        --outfile=greeter.js \
        --format=esm \
        --external:resource://\* \
        --external:gi://\* \
    '';

    installPhase = ''
      mkdir -p $out
      cp -r assets $out
      cp -r style $out
      cp -r greeter $out
      cp -r widget $out
      cp -f main.js $out/config.js
      cp -f greeter.js $out/greeter.js
    '';
  };
in
  stdenv.mkDerivation {
    inherit name;
    src = config;

    installPhase = ''
      mkdir -p $out/bin
      cp -r . $out
      cp ${desktop} $out/bin/${name}
      cp ${greeter} $out/bin/greeter
    '';
  }
