{ config, pkgs,lib, ... }: {
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
      open = true;
      modesetting.enable = lib.mkDefault true;


      prime = {
        amdgpuBusId = "PCI:4:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    services = {
      asusd = {
        enable = true;
      };

      udev.extraHwdb = ''
        evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
         KEYBOARD_KEY_ff31007c=f20    # fixes mic mute button
         KEYBOARD_KEY_ff3100b2=home   # Set fn+LeftArrow as Home
         KEYBOARD_KEY_ff3100b3=end    # Set fn+RightArrow as End
      '';
    };
  services.supergfxd.enable = true;
systemd.services.supergfxd.path = [ pkgs.pciutils ];

# bluetooth
hardware.enableRedistributableFirmware = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;
    wireplumber.extraConfig."monitor.bluez.properties" = {
      "bluez5.enable-sbc-xq" = true;
      "bluez5.enable-msbc" = true;
      "bluez5.enable-hw-volume" = true;
    };
  };
# pro audio config
  security.pam.loginLimits = [
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
  ];
}
