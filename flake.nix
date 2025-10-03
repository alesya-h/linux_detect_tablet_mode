{
  description = "Tablet mode detection and setup scripts for linux";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.linux_detect_tablet_mode = nixpkgs.legacyPackages."x86_64-linux".callPackage ./package.nix { };

    packages.x86_64-linux.default = self.packages.x86_64-linux.linux_detect_tablet_mode;

  };
}
