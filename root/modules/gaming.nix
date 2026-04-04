{ pkgs, ... }: {
  programs.steam.enable = true;
  programs.gamemode.enable = true;

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
}
