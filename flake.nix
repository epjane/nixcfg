{
  description = "NixOS System Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    musnix.url = "github:musnix/musnix";
    flake-programdb.url = "github:tejing1/flake-programdb";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, musnix, flake-programdb }: {
    nixosConfigurations = {
      # stateVersion determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      # keep the value from initial install, even though nixpkgs has been upgraded
      f12 = let stateVersion = "25.05"; in nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { system.stateVersion = stateVersion; }
          ./configuration.nix
          ./hardware-configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.user = {
              imports = [ ./home.nix ];
              home.stateVersion = stateVersion;
            };
          }
          nixos-hardware.nixosModules.framework-12-13th-gen-intel
          musnix.nixosModules.musnix
          flake-programdb.nixosModules.flake-programdb
          { flake-programdb.enable = true; } #fix command-not-found for flakes
        ];
      };
    };
  };
}
