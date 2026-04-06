{ config, pkgs, lib, ... }:

{
  imports = [
    ./modules/desktop.nix
    ./modules/dev.nix
    ./modules/gaming.nix
    ./modules/hardware.nix
    ./modules/polkit.nix
    ./hardware-configuration.nix
  ];

  # --- NIX SETTINGS & OPTIMIZATION ---
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    # Devenv / Cachix binary cache
    extra-trusted-public-keys = [ "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" ];
    extra-substituters = [ "https://devenv.cachix.org" ];
  };

  # Automatic Garbage Collection (keeps your SSD lean)
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nixpkgs.config.allowUnfree = true;

  # systemd boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # host config
  networking.hostName = "p1xlized";
  networking.networkmanager.enable = true;

  # --- locales ---
  time.timeZone = "Europe/Helsinki";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fi_FI.UTF-8";
    LC_IDENTIFICATION = "fi_FI.UTF-8";
    LC_MEASUREMENT = "fi_FI.UTF-8";
    LC_MONETARY = "fi_FI.UTF-8";
    LC_NAME = "fi_FI.UTF-8";
    LC_NUMERIC = "fi_FI.UTF-8";
    LC_PAPER = "fi_FI.UTF-8";
    LC_TELEPHONE = "fi_FI.UTF-8";
    LC_TIME = "fi_FI.UTF-8";
  };

  # Keyboard Layout
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # user config
  users.users.alex = {
    isNormalUser = true;
    description = "Alexandru Paduret";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "podman" ];
    shell = pkgs.fish;
  };

  # shell tools
  programs.fish.enable = true;

  # direvn integration into fish
  programs.fish.interactiveShellInit = ''
    ${pkgs.direnv}/bin/direnv hook fish | source
  '';
  # system packages
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    direnv
    devenv
    btop
    atuin
    fzf
    lsd
    starship
  ];
  system.stateVersion = "25.11";
}
