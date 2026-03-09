let
  systems = {
    yoga = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJEkj0tsVI5ijDz6XsJMc9dhyc0kqOyvlU7jsBYAwSs";
    svp = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFML3gSBoZwIlmKuntb0iP1qikgiU3jyg3FSbgaitzee";
    wsl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIcGZA7hTWlo5o1bmmhqqzVdA1mpcsMfsjASAier8wdl";
  };

  users = {
    iab = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLrQVhdLD9o1Iq17LKFNQ21PaHIAylizOFkvh74FUrz";
    user2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILI6jSq53F/3hEmSs+oq9L4TwOo1PrDMAgcA1uo1CCV/";
  };

  allUsers = builtins.attrValues users;
  allSystems = builtins.attrValues systems;
in
{
  # ragenix -e dae.age
  "dae.age".publicKeys = allUsers ++ allSystems;
  "rclone_infini_pass.age".publicKeys = allUsers ++ allSystems;
  # "secret2.age".publicKeys = [
  #   users.iab
  #   systems.yoga
  # ];
}
