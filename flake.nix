{
  description = "Alex's G14 GA401IV Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    niri.url = "github:sodiboo/niri-flake";
  };

  outputs = { self, nixpkgs, nixos-hardware, niri, ... }@inputs: {
    nixosConfigurations.zephyrus = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        nixos-hardware.nixosModules.asus-zephyrus-ga401
        niri.nixosModules.niri
      ];
    };
  };
}
