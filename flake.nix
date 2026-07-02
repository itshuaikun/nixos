{
  description = "My NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        inherit inputs;
      };

      modules = [
        ({ config, ... }: {
          nixpkgs.overlays = [
            inputs.nur.overlays.default

            (final: prev: {
              unstable = import inputs.nixpkgs-unstable {
                system = final.stdenv.hostPlatform.system;
                config = config.nixpkgs.config;
              };
            })
          ];
        })

        ./configuration.nix
      ];
    };
  };
}
