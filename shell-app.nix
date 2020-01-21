{ghc}:
with (import <nixpkgs> {});
haskell.lib.buildStackProject {
  inherit ghc;
  name = "myEnv";
  buildInputs = [ postgresql zlib ];
}

#{pkgs ? import <nixpkgs> {}}:
#with pkgs;
#let
#in pkgs.mkShell rec {
#  buildInputs = [ postgresql zlib stack nix ];
#  shellHook = ''
#    export NIX_PATH=/home/m013411/.nix-defexpr/channels:nixpkgs=/nix/store/mr92fa4iwcrqfw84jpiisgkp5qx8jdkz-nixpkgs-stable:nixos=/nix/store/mr92fa4iwcrqfw84jpiisgkp5qx8jdkz-nixpkgs-stable:nixos-unstable=/nix/store/shzv2j9blzqmlrl1x6gx0risqqmqwhhc-nixpkgs-unstable
#  '';
#}
