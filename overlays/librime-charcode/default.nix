# WIP
{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  cmake,
  boost,
  icu,
  librime,
}:
stdenvNoCC.mkDerivation rec {
  pname = "librime-charcode";
  version = "2022-02-04";

  src = fetchFromGitHub {
    owner = "rime";
    repo = pname;
    rev = "e20e3993c42fc86c8209e808ed0762aea24261e0";
    sha256 = "sha256-MHDirPoApNfXpc01M+Xq7p+MiS+pJaxuDo3aROc80e0=";
  };

  # There is a Makefile, but we don’t need it, and it prints errors
  dontBuild = true;

  dontInstall = true;


  # nativeBuildInputs = [cmake];

  # buildInputs = [boost icu librime];

  meta = with lib; {
    description = "librime-charcode";
    homepage = "https://github.com/rime/librime-charcode";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ zendo ];
  };
}
