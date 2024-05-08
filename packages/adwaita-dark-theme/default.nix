{
  lib,
  emacsPackages,
  fetchgit,
  ...
}:
emacsPackages.trivialBuild rec {
  pname = "adwaita-dark-theme";
  version = "1.3.0";

  src = fetchgit {
    url = "https://git.tty.dog/jessieh/adwaita-dark-theme.git";
    rev = version;
    sha256 = "sha256-Y5BApZPgWK8eAqAB4N1wXdsMr7Rt/JzoPcOiw61CFYI=";
  };

  meta = {
    homepage = "https://git.tty.dog/jessieh/adwaita-dark-theme";
    description = "A dark color scheme that aims to replicate the appearance and colors of GTK4 \"libadwaita\" applications.";
    license = lib.licenses.gpl2;
  };
}
