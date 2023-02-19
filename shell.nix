{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  packages = [
    (pkgs.lua.withPackages (ps: with ps; [ busted ]))
  ];
}
