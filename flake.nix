{
  description = "Flake for rapid VPS";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.hardware.url = "github:nixos/nixos-hardware";

  outputs = { nixpkgs, ... }@inputs: rec {
    legacyPackages = nixpkgs.lib.genAttrs [ "x86_64-linux" "x86_64-darwin" ] (system:
      import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      }
    );

    nixosConfigurations = {
      vps = nixpkgs.lib.nixosSystem {
        pkgs = legacyPackages.x86_64-linux;
        specialArgs = { inherit inputs; }; # Pass flake inputs to our config
        modules = [ ./configuration.nix ];
      };
    };
  };
}
