{ config, pkgs, ... }: {
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # This forces Podman's CLI wrapper to map directly to the NixOS package location
  environment.sessionVariables = {
    PODMAN_COMPOSE_PROVIDER = "${pkgs.podman-compose}/bin/podman-compose";
  };

  environment.systemPackages = with pkgs; [
    git
    distrobox
    zed-editor
    jetbrains.idea-oss
    yaak
    firefox-devedition
    podman-compose
    docker-compose
  ];
}
