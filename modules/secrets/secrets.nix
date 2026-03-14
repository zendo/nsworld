let
  systems = {
    yoga = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOaubBTa8qwJcVxuukrSQkEM3wQmaqI0RQHUyEADpz/7";
    svp = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFC7qvKb3CgEXVKrF9HybyHIdnesvXmuVp7ElsEDkkHf";
    rmt = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIATekMmx7K+49Xt3k7S2zi8L8XIGwNDwgN+Z9OykOb0m";
    wsl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIcGZA7hTWlo5o1bmmhqqzVdA1mpcsMfsjASAier8wdl";
  };

  users = {
    # https://github.com/zendo.keys
    zendo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLrQVhdLD9o1Iq17LKFNQ21PaHIAylizOFkvh74FUrz";
    user2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILI6jSq53F/3hEmSs+oq9L4TwOo1PrDMAgcA1uo1CCV/";
  };

  allUsers = builtins.attrValues users;
  allSystems = builtins.attrValues systems;
in
{
  # ragenix -e dae.age
  "dae.age".publicKeys = allSystems ++ [ users.zendo ];
  "infini_pass.age".publicKeys = allSystems ++ allUsers;
  # "secret2.age".publicKeys = [
  #   users.iab
  #   systems.yoga
  # ];
}
