{ lib
, stdenv
, fetchFromGitHub
, nasm
}:

stdenv.mkDerivation rec {
  pname = "snake-asm";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "NikitaIvanovV";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-f3AoGm2olPLLkwfbqnTHXfH0B+7/ZJxXy+/4rfMweqY=";
  };

  nativeBuildInputs = [ nasm ];

  buildInputs = [
  ];

  postPatch = ''
    substituteInPlace Makefile \
    --replace '/usr/local' "$out"
  '';

  meta = with lib; {
    description = "Tiny snake game written in x86_64 assembly for Linux";
    homepage = "https://github.com/NikitaIvanovV/snake-asm";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
