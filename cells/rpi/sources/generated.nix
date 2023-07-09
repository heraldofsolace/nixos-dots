# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  libcamera = {
    pname = "libcamera";
    version = "2783c8d8aa97cf1df21d8480840a6276bc2bd272";
    src = fetchFromGitHub {
      owner = "raspberrypi";
      repo = "libcamera";
      rev = "2783c8d8aa97cf1df21d8480840a6276bc2bd272";
      fetchSubmodules = false;
      sha256 = "sha256-t0RLvmeD4ipx65JShrbp+KCQiJJWZWabML62Y9/ZwWY=";
    };
    date = "2023-07-07";
  };
  libcamera-apps = {
    pname = "libcamera-apps";
    version = "d932d3132a2414b976a08373ff8dc5e83f568ef5";
    src = fetchFromGitHub {
      owner = "raspberrypi";
      repo = "libcamera-apps";
      rev = "d932d3132a2414b976a08373ff8dc5e83f568ef5";
      fetchSubmodules = false;
      sha256 = "sha256-Zv83ia2bf1IsEgJUWNPwEhl3AxWzxkuxvov/kBZ4gj0=";
    };
    date = "2023-06-30";
  };
  mediamtx = {
    pname = "mediamtx";
    version = "625e7da91d3991f366283597ab5002290811449e";
    src = fetchFromGitHub {
      owner = "bluenviron";
      repo = "mediamtx";
      rev = "625e7da91d3991f366283597ab5002290811449e";
      fetchSubmodules = false;
      sha256 = "sha256-D3JVSDeWCzrzzi2bmlD7zT7+50aR6ebkf4InG71diNg=";
    };
    date = "2023-07-07";
  };
}
