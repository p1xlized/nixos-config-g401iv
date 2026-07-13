{ pkgs, lib, inputs, ... }: {

  # 1. Core Desktop & Power Services
  programs.niri.enable = true;
  services.displayManager.ly.enable = true;
  services.power-profiles-daemon.enable = true; # Restored - works great with modern asusctl
  services.upower.enable = true;
  services.flatpak.enable = true;
  fonts.fontDir.enable = true;
  services.gvfs.enable = true;

  # 2. ASUS Laptop Integration
  services.asusd = {
    enable = true;
  };

  # 3. Supergfxctl Daemon (Explicitly Tuned for Ly + G14)
  services.supergfxd = {
    enable = true;
    settings = {
      mode = "Integrated";
      vfio_enable = false;
      vfio_save = false;
      always_reboot = true;
      no_logind = true;        # FIX: Prevents text-mode managers like Ly from crashing on state changes
      logout_timeout_s = 30;
      hotplug_type = "Asus";   # FIX: Tailored directly for the ASUS hardware routing ACPI
    };
  };

  # Make sure the daemon can access hardware discovery tools inside its systemd context
  systemd.services.supergfxd.path = [ pkgs.pciutils pkgs.kmod ];

  # 4. Graphics Drivers Setup (Mandatory for supergfxctl to orchestrate switches)
  services.xserver.videoDrivers = [ "nvidia" "amdgpu" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true; # Allows deep sleep when supergfxctl unloads the driver
    open = true;                   # Recommended for modern G14s (Turing architecture and up)
  };

  # Make sure both graphics stacks are initialized early at boot phase
  boot.initrd.kernelModules = [ "amdgpu" "nvidia" "nvidia-drm" "nvidia-modeset" ];

  # --- Rest of your standard layout ---
  systemd.user.settings.Manager = {
    DefaultEnvironment = "PATH=/run/current-system/sw/bin";
  };
  services.dbus.packages = [ pkgs.gcr ];

  systemd.user.services.xdg-desktop-portal-gtk = {
    serviceConfig = { Restart = "on-failure"; RestartSec = 1; };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome pkgs.xdg-desktop-portal-gtk pkgs.xdg-user-dirs ];
    config = {
      common.default = [ "gtk" ];
      niri = lib.mkForce {
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        "org.freedesktop.impl.portal.AppChooser" = [ "gtk" ];
        "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
        "org.freedesktop.impl.portal.OpenURI" = [ "gtk" ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    waybar swaylock awww adwaita-icon-theme xwayland-satellite nautilus glib ghostty vicinae evtest appimage-run
    asusctl # Gives you user utilities for fan profiles/charge limit control
  ];
}
