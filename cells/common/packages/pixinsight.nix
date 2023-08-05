{
  stdenv,
  lib,
  requireFile,
  buildFHSUserEnv,
  breakpointHook,
  wrapQtAppsHook,
  autoPatchelfHook,
  makeWrapper,
  unixtools,
  fakeroot,
  mime-types,
  libGL,
  libpulseaudio,
  alsa-lib,
  nss,
  gd,
  gst_all_1,
  nspr,
  expat,
  fontconfig,
  dbus,
  glib,
  zlib,
  openssl,
  libdrm,
  cups,
  avahi-compat,
  xorg,
  wayland,
  libudev0-shim,
  # Qt 5 subpackages
  qt5,
  # libsForQt5 sub packages.
  qt3d,
  mlt,
  ...
}:
stdenv.mkDerivation rec {
  pname = "pixinsight";
  version = "1.8.9-1";

  src = requireFile rec {
    name = "./_files/PI-linux-x64-${version}-20220518-t.tar.xz";
    url = "https://pixinsight.com/";
    sha1 = "87c7274f13c50884ecf42012129819553b0cfbc4";
  };
  sourceRoot = ".";

  nativeBuildInputs = [
    unixtools.script
    fakeroot
    wrapQtAppsHook
    autoPatchelfHook
    breakpointHook
    mime-types
    libudev0-shim
  ];

  buildInputs =
    [
      stdenv.cc.cc.lib
      stdenv.cc
      libGL
      libpulseaudio
      alsa-lib
      nss
      gd
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      nspr
      expat
      fontconfig
      dbus
      glib
      zlib
      openssl
      libdrm
      wayland
      cups
      avahi-compat
      # Qt stuff
      qt3d
      mlt
    ]
    ++ (with xorg; [
      libX11
      libXdamage
      xrandr
      libXtst
      libXcomposite
      libXext
      libXfixes
      libXrandr
    ])
    ++ (with qt5; [
      qtbase
      qtgamepad
      qtserialport
      qtserialbus
      qtvirtualkeyboard
      qtmultimedia
      qtwebkit
    ]);

  postPatch = ''
    patchelf ./installer \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${stdenv.cc.cc.lib}/lib
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    # mkdir -p $out/share/{applications,mime/packages,icons/hicolor}
    mkdir -p $out/bin $out/opt/PixInsight $out/share/{applications,mime/packages,icons/hicolor}

    fakeroot script -ec "./installer \
      --yes \
      --install-dir=$out/opt/PixInsight \
      --install-desktop-dir=$out/share/applications \
      --install-mime-dir=$out/share/mime \
      --install-icons-dir=$out/share/icons/hicolor \
      --no-bin-launcher \
      --no-remove"

    rm -rf $out/opt/PixInsight-old-0
    ln -s $out/opt/PixInsight/bin/PixInsight $out/bin/.
  '';

  # Some very exotic Qt libraries are not available in nixpkgs
  autoPatchelfIgnoreMissingDeps = true;

  # This mimics what is happening in PixInsight.sh and adds on top the libudev0-shim, which
  # without PixInsight crashes at startup.
  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${libudev0-shim}/lib"
    "--set LC_ALL en_US.utf8"
    "--set AVAHI_COMPAT_NOWARN 1"
    "--set QT_PLUGIN_PATH $out/opt/PixInsight/bin/lib/qt-plugins"
    "--set QT_QPA_PLATFORM_PLUGIN_PATH $out/opt/PixInsight/bin/lib/qt-plugins/platforms"
    "--set QT_AUTO_SCREEN_SCALE_FACTOR 0"
    "--set QT_ENABLE_HIGHDPI_SCALING 0"
    "--set QT_SCALE_FACTOR 1"
    "--set QT_LOGGING_RULES '*=false'"
    "--set QTWEBENGINEPROCESS_PATH $out/opt/PixInsight/bin/libexec/QtWebEngineProcess"
  ];
  dontWrapQtApps = true;
  postFixup = ''
    wrapProgram $out/opt/PixInsight/bin/PixInsight ${builtins.toString qtWrapperArgs}
  '';
}
