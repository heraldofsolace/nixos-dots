{
  inputs,
  cell,
}: {pkgs, ...}: {
  home.packages = with pkgs; [
    python311
    python311Packages.pip
    python311Packages.ipython
    python311Packages.black
    python311Packages.setuptools
    python311Packages.pylint
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
