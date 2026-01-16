{
  lib,
  pkgs,
}:
# FIXME: remove when https://github.com/NixOS/nixpkgs/pull/351880
# is merged
pkgs.stdenv.mkDerivation rec {
  pname = "http_proxy_connect_module";
  version = "4f0b6c2297862148c59a0d585d6c46ccb7e58a39";

  src = pkgs.fetchFromGitHub {
    owner = "chobits";
    repo = "ngx_http_proxy_connect_module";
    rev = version;
    sha256 = "sha256-Yob2Z+a3ex3Ji6Zz8J0peOYnKpYn5PlC9KsQNcHCL9o=";
  };

  patches = [ "${src}/patch/proxy_connect_rewrite_102101.patch" ];

  meta = {
    license = [ lib.licenses.bsd2 ];
    description = "Forward proxy module for handling CONNECT requests";
    homepage = "https://github.com/chobits/ngx_http_proxy_connect_module";
  };
}
