{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule (self: {
  pname = "connections";
  version = "0.1.21";

  src = fetchFromGitHub {
    owner = "jmelahman";
    repo = "connections";
    tag = "v${self.version}";
    hash = "sha256-Z5grTN9ZLmkmBSMs8WTJ/JAWndZyx1O16tK0U0MPxqc=";
  };

  vendorHash = "sha256-qyI3BbadwzRAJ+09uNRJ+gvhn+Px0JjqwGwXF7fC7KE=";

  meta = {
    description = "A command-line client for the NYT Connections game.";
    homepage = "https://github.com/jmelahman/connections";
    license = lib.licenses.mit;
    mainProgram = "connections";
  };
})
