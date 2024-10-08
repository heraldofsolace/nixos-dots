# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  libcamera = {
    pname = "libcamera";
    version = "6ddd79b5bdbedc1f61007aed35391f1559f9e29a";
    src = fetchFromGitHub {
      owner = "raspberrypi";
      repo = "libcamera";
      rev = "6ddd79b5bdbedc1f61007aed35391f1559f9e29a";
      fetchSubmodules = false;
      sha256 = "sha256-qqEMJzMotybf1nJp1dsz3zc910Qj0TmqCm1CwuSb1VY=";
    };
    date = "2024-06-17";
  };
  libcamera-apps = {
    pname = "libcamera-apps";
    version = "511941fdb1fed8f10668c6177639bcc7770b672d";
    src = fetchFromGitHub {
      owner = "raspberrypi";
      repo = "libcamera-apps";
      rev = "511941fdb1fed8f10668c6177639bcc7770b672d";
      fetchSubmodules = false;
      sha256 = "sha256-/phg1h344bI6c6E+2qrto2U6pvDblAwnnobnb/xYhYE=";
    };
    date = "2024-08-13";
  };
  mediamtx = {
    pname = "mediamtx";
    version = "aa1822dd62d15080245869ccb80d643f7bdf8f15";
    src = fetchFromGitHub {
      owner = "bluenviron";
      repo = "mediamtx";
      rev = "aa1822dd62d15080245869ccb80d643f7bdf8f15";
      fetchSubmodules = false;
      sha256 = "sha256-YTaULVghPC+luidbjeNLe7QWettGNDG5jjkS87zFwVU=";
    };
    date = "2024-08-23";
  };
}
