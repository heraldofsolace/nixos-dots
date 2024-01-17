{xdg-desktop-portal, ...}:
xdg-desktop-portal.overrideAttrs (o: rec {
  mesonFlags = o.mesonFlags ++ ["-Dpytest=disabled"];
  doCheck = false;
})
