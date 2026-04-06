{ pkgs, lib, ... }: {
  programs.niri.enable = true;
  services.displayManager.ly.enable = true;
  services.power-profiles-daemon.enable = true;

  services.flatpak.enable = true;
  fonts.fontDir.enable = true;
  systemd.user.extraConfig = ''
      DefaultEnvironment="PATH=/run/current-system/sw/bin"
    '';

    # Tell systemd to restart the portal if it fails (like it did in your logs)
    systemd.user.services.xdg-desktop-portal-gtk = {
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 1;
      };
    };
    # Ensure the portal knows how to talk to Flatpaks

    xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gnome pkgs.xdg-desktop-portal-gtk pkgs.xdg-user-dirs ];
        config = {
          common.default = [ "gtk" ]; # Try setting gtk as the global default
          niri = lib.mkForce {
            "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
            "org.freedesktop.impl.portal.Settings" = [ "gnome" ];
          };
        };
      };

  environment.systemPackages = with pkgs; [
    waybar xwayland-satellite vicinae swaylock swayidle nautilus awww ghostty
  ];
}
