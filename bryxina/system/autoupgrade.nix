{ config, lib, pkgs, ... }:

{
  system.autoUpgrade = {
    enable = true;
    dates = "daily";
    persistent = true;
    flake = "github:apinter/nix-config";
    flags = [ 
      "--no-write-lock-file"
      ];
    allowReboot = true;
    randomizedDelaySec = "15min";
  };
}
