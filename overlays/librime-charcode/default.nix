# WIP
{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  icu,
  librime,
}:
stdenv.mkDerivation rec {
  pname = "librime-charcode";
  version = "2022-02-04";

  src = fetchFromGitHub {
    owner = "rime";
    repo = pname;
    rev = "e20e3993c42fc86c8209e808ed0762aea24261e0";
    sha256 = "sha256-MHDirPoApNfXpc01M+Xq7p+MiS+pJaxuDo3aROc80e0=";
  };

  dontInstall = true;

  # nativeBuildInputs = [cmake];

  # buildInputs = [boost icu librime];
}
