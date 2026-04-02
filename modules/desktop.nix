{ pkgs, ... }: {
  # --- SHELL & TERMINAL TOOLS ---
  programs.fish.enable = true;

  # --- DISPLAY & UI ---
  services.displayManager.ly.enable = true;
  programs.niri.enable = true;

  # --- VIRTUALIZATION ---
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # --- HARDWARE: BLUETOOTH & FIRMWARE ---
  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  # --- BASE APPS ---
  environment.systemPackages = with pkgs; [
    ghostty
    waybar
    vicinae
    alacritty
    git
    blueman
    distrobox
    fzf         # Fuzzy finder
    lsd         # Modern replacement for 'ls'
    fd          # Faster 'find' (works great with fzf)
  ];
  # flatpak
  services.flatpak.enable = true;

    # Optional: Integration for XDG portals (Required for Niri/Wayland)
    # This allows Flatpaks to open file pickers and screen share
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ]; # Or -gtk/-wlr
      config.common.default = "*";
    };
  # --- AUDIO (Pipewire + Bluetooth + Real-Time) ---
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;

    wireplumber.extraConfig = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
      };
    };
  };

  # --- REAL-TIME AUDIO PERMISSIONS ---
  security.pam.loginLimits = [
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
  ];

  # --- MISC ---
  environment.variables.NIXOS_OZONE_WL = "1";
}
