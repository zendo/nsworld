{ lib
, bundlerApp
, bundlerUpdateScript
}:

bundlerApp {
  pname = "bashly";

  gemdir = ./.;
  exes = [ "bashly" ];

  passthru.updateScript = bundlerUpdateScript "bashly";

  meta = with lib; {
    description = "Bash command line framework and CLI generator";
    homepage = "https://github.com/DannyBen/bashly";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
