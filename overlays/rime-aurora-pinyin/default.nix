{ lib
, fetchFromGitHub
, stdenvNoCC
}:

stdenvNoCC.mkDerivation rec {
  pname = "rime-aurora-pinyin";
  version = "2022-08-28";

  src = fetchFromGitHub {
    owner = "hosxy";
    repo = pname;
    rev = "122b46976401995cbafcfc748806985ff3a437a4";
    hash = "sha256-zLzQXSsKwgr7OsyYllyoLNSF9q4mJA5ZYD7v7oagfaE=";
  };

  installPhase = ''
    mkdir -p $out/share/rime-data
    cp *.yaml $_
  '';

  meta = with lib; {
    description = "【极光拼音】输入方案";
    homepage = "https://github.com/hosxy/rime-aurora-pinyin";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ zendo ];
  };
}
