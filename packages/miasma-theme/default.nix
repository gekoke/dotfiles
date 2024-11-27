{
  lib,
  emacsPackages,
  fetchFromGitHub,
  ...
}:
emacsPackages.trivialBuild rec {
  pname = "miasma-theme";
  version = "7651717";

  src = fetchFromGitHub {
    owner = "daut";
    repo = "miasma-theme.el";
    rev = version;
    hash = "sha256-0k7yFtyRKcMGniTil5AgiFixSyqm4mrhR7rvoHBv+AE=";
  };

  meta = {
    homepage = "https://github.com/daut/miasma-theme.el";
    license = lib.licenses.gpl3;
  };
}
