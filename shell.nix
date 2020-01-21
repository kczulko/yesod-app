let
  inherit (import <nixpkgs> {}) fetchFromGitHub;
  nixpkgs = fetchFromGitHub {
    owner  = "NixOS";
    repo   = "nixpkgs-channels";
    rev    = "d14cea0dec2dd59e19457180feef315054ba8c57";
    sha256 = "1jmfj8az48ifli39ww1yxhi489pfkcnb5zmiv6x117v37zbv3mr5";
  };
  pkgs = import nixpkgs {};
in
pkgs.haskellPackages.developPackage {
  root = ./.;
  modifier = drv:
    pkgs.haskell.lib.addBuildTools drv (with pkgs.haskellPackages;
      [ cabal-install
        ghcid
      ]);
}
