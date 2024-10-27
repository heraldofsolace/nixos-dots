{pkgs ? import <nixpkgs> {}}: let
  pykrige = pkgs.python3Packages.buildPythonPackage rec {
    pname = "pykrige";
    version = "1.7.2";

    src = pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-JbRaQXNxTAtiCY0ZAZQEyzl4+ovYq66bpVonKlOXnjU=";
    };

    buildInputs = with pkgs.python3Packages; [
      cython
    ];

    propagatedBuildInputs = with pkgs.python3Packages; [
      numpy
      scipy
    ];
  };

  xisf = pkgs.python3Packages.buildPythonPackage rec {
    pname = "xisf";
    version = "0.9.5";

    src = pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-FMGc+QBg04u48pnwDskD7vF+mnVwn7YwjhL2NJuYm2g=";
    };

    pyproject = true;
    build-system = [
      pkgs.python3Packages.setuptools
      pkgs.python3Packages.setuptools-scm
    ];

    propagatedBuildInputs = with pkgs.python3Packages; [
      numpy
      lz4
      zstandard
    ];
  };
  python = let
    packageOverrides = self: super: {
      scikit-image = super.scikit-image.overridePythonAttrs (oldAttrs: rec {
        version = "0.21.0";
        src = super.fetchPypi {
          pname = "scikit-image";
          inherit version;
          sha256 = "";
        };
      });
    };
  in
    pkgs.python3.override {
      inherit packageOverrides;
      self = python;
    };
in
  pkgs.python3Packages.buildPythonApplication rec {
    pname = "graxpert";
    version = "3.0.2";

    nativeBuildInputs = with pkgs; [
      git
      tk
    ];

    build-system = with pkgs.python3Packages; [
      setuptools
      wheel
    ];

    buildInputs = with pkgs.python3Packages; [
      cx-freeze
      tkinter
    ];

    propagatedBuildInputs = with pkgs.python3Packages; [
      appdirs
      astropy
      customtkinter
      minio
      ml-dtypes
      numpy
      pillow
      pykrige
      opencv4
      requests
      scikit-image
      scipy
      xisf
    ];

    src = pkgs.fetchFromGitHub {
      owner = "Steffenhir";
      repo = "GraXpert";
      rev = version;
      deepClone = true;
      leaveDotGit = true;
      sha256 = "sha256-U1qfXYn6iyXyZN3ypMSJuOuavwbVKC8b+WeFVEb775M=";
    };

    patchPhase = ''
      chmod u+x ./releng/patch_version.sh
      source ./releng/patch_version.sh
    '';
  }
