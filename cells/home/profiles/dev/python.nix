{
  inputs,
  cell,
}: {pkgs, ...}: {
  home.packages = with pkgs; [
    python313
    python313Packages.pip
    python313Packages.ipython
    python313Packages.black
    python313Packages.setuptools
    python313Packages.pylint
  ];

  home.shellAliases = {
    py = "python";
    py2 = "python2";
    py3 = "python3";
    po = "poetry";
    ipy = "ipython --no-banner";
    ipylab = "ipython --pylab=qt5 --no-banner";
  };
}
