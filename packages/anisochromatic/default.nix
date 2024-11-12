{
  lib,
  emacsPackages,
  fetchFromGitHub,
  ...
}:
emacsPackages.trivialBuild rec {
  pname = "anisochromatic";
  version = "8e58416a86981b991c7e275668d70845a67d9a90";

  src = fetchFromGitHub {
    owner = "isomatter-labs";
    repo = "anisochromatic-emacs";
    rev = version;
    hash = "sha256-+PjsHtSvsYtQlJ/Ccucivy7k/dfoBQPz+eBDam9W87o=";
  };

  buildInputs = propagatedUserEnvPkgs;

  propagatedUserEnvPkgs = [ emacsPackages.autothemer ];

  meta = {
    homepage = "https://github.com/isomatter-labs/anisochromatic-emacs/";
    license = lib.licenses.mit;
  };
}
