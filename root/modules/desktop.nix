{ pkgs, lib, ... }: {
  programs.niri.enable = true;
  services.displayManager.ly.enable = true;
  services.power-profiles-daemon.enable = true;

  services.flatpak.enable = true;
  fonts.fontDir.enable = true;

    # Ensure the portal knows how to talk to Flatpaks

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome pkgs.xdg-desktop-portal-gtk ];
    config = {
      common.default = [ "gnome" "gtk" ];
      niri = lib.mkForce {
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        "org.freedesktop.impl.portal.Settings" = [ "gnome" ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    waybar xwayland-satellite vicinae swaylock swayidle nautilus atuin fzf lsd
  ];
}
