{
  gcc8Stdenv,
  lib,
  fetchFromGitHub,
  pkgconfig,
  xorg,
  gtk2,
  ...
}:
gcc8Stdenv.mkDerivation rec {
  name = "cellwriter-${version}";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "risujin";
    repo = "cellwriter";
    rev = version;
    sha256 = "05ha08fx15ywxh5cbhqsb79yw5xbq2cgpkgi46nlvw5560p9fi46";
  };

  nativeBuildInputs = [pkgconfig xorg.xorgproto];
  buildInputs = [gtk2 xorg.libX11 xorg.libXtst];

  meta = with lib; {
    description = "Grid-entry natural handwriting input panel";
    homepage = "https://github.com/risujin/cellwriter";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
