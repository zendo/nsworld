{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.ruby
    pkgs.go
    pkgs.sqlite
  ];
}
