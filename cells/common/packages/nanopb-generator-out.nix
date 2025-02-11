{
  stdenv,
  cmake,
  python3,
  writeTextFile,
  protobuf,
  src,
  version,
}: let
  pyproject_toml = writeTextFile {
    name = "pyproject.toml";
    text = ''
      [build-system]
      requires = ["setuptools"]
      build-backend = "setuptools.build_meta"

      [tool.setuptools]
      include-package-data = true

      [tool.setuptools.packages.find]
      where = ["src"]

      [tool.setuptools.package-data]
      "*" = ["nanopb.proto"]

      [project]
      name = "nanopb"
      version = "${version}"
      dependencies = [
        "setuptools",
        "protobuf",
        "six"
      ]
    '';
  };
in
  stdenv.mkDerivation {
    pname = "nanopb-generator-out";
    inherit src version;

    nativeBuildInputs = [
      cmake
      protobuf
    ];

    # don't let `find_program` find the bundled `protoc` script, so it will use the system `protoc` instead
    preConfigure = ''
      rm generator/protoc
    '';

    cmakeFlags = [
      "-Dnanopb_BUILD_RUNTIME=OFF"
      "-Dnanopb_BUILD_GENERATOR=ON"
      "-Dnanopb_PYTHON_INSTDIR_OVERRIDE=${placeholder "out"}/${python3.sitePackages}"
    ];

    postInstall = ''
      rm -rf $out/include
      rm -rf $out/lib/cmake
      ln -s $out/${python3.sitePackages} $out/src
      ln -s ${pyproject_toml} $out/pyproject.toml
    '';
  }
