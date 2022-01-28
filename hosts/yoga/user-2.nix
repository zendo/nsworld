{ config, ... }:

{
  users.users.zen = {
    isNormalUser = true;
    hashedPassword = "$6$LuQacq/E/Dy9uw.I$PdSDOZ3H7vRVgZ3vNpiuX2TWRvupaB6wfpaVDhLMB3zQ4WUHF6/Vh./YI01voWCUAeIZjg3poQSGvBIUGxiVJ/";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "docker" ];
  };


}
