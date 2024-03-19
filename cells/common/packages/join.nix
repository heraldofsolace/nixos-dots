{
  appimageTools,
  fetchurl,
  ...
}:
appimageTools.wrapAppImage rec {
  pname = "join";
  version = "1.1.2";

  src = appimageTools.extract {
    inherit pname version;
    src = fetchurl {
      url = "https://github.com/joaomgcd/JoinDesktop/releases/download/v${version}/Join.Desktop-${version}.AppImage";
      hash = "sha256-tcM8CCr3XtFIp1ntPO43CgW2UUIKRGAwpDVEgInR5zU=";
    };
  };
  extraPkgs = pkgs: with pkgs; [];

  extraInstallCommands = ''
     # Now, install assets such as the desktop file and icons
    install -m 444 -D ${src}/com.joaomgcd.join.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/com.joaomgcd.join.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}-${version}'
    cp -r ${src}/usr/share/icons $out/share
  '';
}
