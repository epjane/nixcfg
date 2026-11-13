{
  description = "NixOS System Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    musnix.url = "github:musnix/musnix";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, musnix }: {
    nixosConfigurations = {
      f12 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.user = import ./home.nix;
          }
          nixos-hardware.nixosModules.framework-12-13th-gen-intel
          musnix.nixosModules.musnix
        ];
      };
    };
  };
}
