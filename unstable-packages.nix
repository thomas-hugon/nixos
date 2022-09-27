{ config, pkgs, ... }:
let
  baseconfig = { allowUnfree = true; };
  unstable = import <nixos-unstable> { config = baseconfig; };
in {
  environment.systemPackages = with pkgs; [
  ];

  users.users.thomas.packages = with pkgs; [
    unstable.jetbrains.idea-ultimate
  ];

}
