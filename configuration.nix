{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix # This is the ONLY file we don't pre-write
    ./modules/hardware.nix
    ./modules/desktop.nix
    ./modules/gaming.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "zephyrus";
  networking.networkmanager.enable = true;

  users.users.alex = {
    isNormalUser = true;
    shell = pkgs.fish; # <--- Sets Fish as your default shell
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "podman" ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";
}
