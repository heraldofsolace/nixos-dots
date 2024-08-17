{
  inputs,
  cell,
}: {pkgs, ...}: {
  home.packages = with pkgs; [
    python312
    python312Packages.pip
    python312Packages.ipython
    python312Packages.black
    python312Packages.setuptools
    python312Packages.pylint
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
