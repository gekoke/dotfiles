{ pkgs, ...}:
{
  haskellShell = pkgs.mkShell {
    name = "Haskell";
    packages = with pkgs; [
      haskell.compiler.ghc902
      cabal-install
      haskell-language-server
    ];
  };
}
