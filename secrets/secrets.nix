let
  mi = "ssh-ed25519 AAAAC3NzaC1lZDI1iaLghPZBH8VTd";

  io = "ssh-ed25519 AAAAC3NzaC5PwI0DxW9H00 root@i";
in
{
  "ss.age".publicKeys = [ mi io ];
}
