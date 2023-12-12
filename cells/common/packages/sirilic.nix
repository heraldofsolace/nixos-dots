{
  lib,
  python3Packages,
  wrapGAppsHook,
  fetchFromGitLab,
  ...
}:
with python3Packages;
  buildPythonApplication rec {
    pname = "sirilic";
    version = "1.15.8";

    propagatedBuildInputs = [wxPython_4_2 requests];
    doCheck = false;
    nativeBuildInputs = [wrapGAppsHook];

    src = fetchFromGitLab {
      owner = "free-astro";
      repo = "sirilic";
      rev = "V${version}";
      sha256 = "juWjHJp74du0m88MjR3Ybs2WYqU+El3J8Zc1o9Is9dk=";
    };
  }
