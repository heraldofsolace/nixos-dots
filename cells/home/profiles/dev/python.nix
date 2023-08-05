{
  inputs,
  cell,
}: {pkgs, ...}: {
  home.packages = with pkgs; [
    python310
    python310Packages.pip
    python310Packages.ipython
    python310Packages.black
    python310Packages.setuptools
    python310Packages.pylint
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
