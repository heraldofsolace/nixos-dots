{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  pkg-config,
  meson,
  ninja,
  cmake,
  git,
  criterion,
  gtk3,
  libconfig,
  gnuplot,
  opencv,
  json-glib,
  fftwFloat,
  cfitsio,
  gsl,
  exiv2,
  librtprocess,
  wcslib,
  ffmpeg,
  libraw,
  libtiff,
  libpng,
  libjpeg,
  libheif,
  ffms,
  wrapGAppsHook,
  glib-networking,
  curl,
  ...
}:
stdenv.mkDerivation rec {
  pname = "siril-new2";
  version = "1.2.4";

  src = fetchFromGitLab {
    owner = "free-astro";
    repo = "siril";
    rev = version;
    hash = "sha256-orNu9qo7sutMUPeIPPhxKETEKbCm4D6nAuo4Hc/8Bdo=";
  };

  # patches = [
  #   (fetchpatch {
  #     name = "siril-1.2-exiv2-0.28.patch";
  #     url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sci-astronomy/siril/files/siril-1.2-exiv2-0.28.patch?id=002882203ad6a2b08ce035a18b95844a9f4b85d0";
  #     hash = "sha256-R1yslW6hzvJHKo0/IqBxkCuqcX6VrdRSz68gpAExxVE=";
  #   })
  # ];

  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkg-config
    git
    criterion
    wrapGAppsHook
    glib-networking
    curl
  ];

  buildInputs = [
    gtk3
    cfitsio
    gsl
    exiv2
    gnuplot
    opencv
    fftwFloat
    librtprocess
    wcslib
    libconfig
    libraw
    libtiff
    libpng
    libjpeg
    libheif
    ffms
    ffmpeg
    json-glib
    glib-networking
    curl
  ];

  # Necessary because project uses default build dir for flatpaks/snaps
  dontUseMesonConfigure = true;
  dontUseCmakeConfigure = true;

  configureScript = ''
    ${meson}/bin/meson setup --buildtype release -Denable-libcurl=yes nixbld .
  '';

  postConfigure = ''
    cd nixbld
  '';

  meta = with lib; {
    homepage = "https://www.siril.org/";
    description = "Astrophotographic image processing tool";
    license = licenses.gpl3Plus;
    changelog = "https://gitlab.com/free-astro/siril/-/blob/HEAD/ChangeLog";
    maintainers = with maintainers; [hjones2199];
    platforms = platforms.linux;
  };
}
