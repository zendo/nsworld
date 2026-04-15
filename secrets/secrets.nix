let
  hostkey = {
    yoga = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOaubBTa8qwJcVxuukrSQkEM3wQmaqI0RQHUyEADpz/7";
    yoga-age = "age1jmm676z8v5nkmmlrvz0pdne99spjen43l2myl4h8cvng5ptemunsnqz564";
    svp = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFC7qvKb3CgEXVKrF9HybyHIdnesvXmuVp7ElsEDkkHf";
    svp-age = "age1l46tamf9lgx47xqvy2dqc4qhlhwlwsruzky0qnfvewtsw205wd8qc6alyq";
    rmt = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIATekMmx7K+49Xt3k7S2zi8L8XIGwNDwgN+Z9OykOb0m";
    rmt-age = "age1dcyjdpcfjav8dlnh383gq8ppp4y2k9ewjnuf5sggt35erh8svdrsysvrfj";
    wsl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIcGZA7hTWlo5o1bmmhqqzVdA1mpcsMfsjASAier8wdl";
    wsl-age = "age1jvqz7uyl5x23vzcuseuk363kzza869v9rh7nsqj4srqx6tyjhv2qsc32ww";
  };

  users = {
    # https://github.com/zendo.keys
    zendo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLrQVhdLD9o1Iq17LKFNQ21PaHIAylizOFkvh74FUrz";
    user2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILI6jSq53F/3hEmSs+oq9L4TwOo1PrDMAgcA1uo1CCV/";
  };

  allUsers = builtins.attrValues users;
  allHosts = builtins.attrValues hostkey;
in
{
  # ragenix -e dae.age
  "dae.age".publicKeys = allHosts ++ [ users.zendo ];
  "infini_pass.age".publicKeys = allHosts ++ allUsers;
  # "secret2.age".publicKeys = [
  #   users.iab
  #   systems.yoga
  # ];
}
