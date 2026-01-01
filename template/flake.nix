{
  description = "A repository with Nix modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    {
      # Export all modules from the modules directory
      nixosModules = {
        default = import ./modules;
        # To export individual modules, access them from the default import:
        # example = (import ./modules).example;
      };

      # Overlay for packages
      overlays.default = final: prev: {
        # Add package overlays here
      };
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # Development environment
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nix
            git
            nixpkgs-fmt
          ];

          shellHook = ''
            echo "Development environment for Nix modules"
            echo "Available commands:"
            echo "  nix flake check    # Check flake validity"
            echo "  nix flake show     # Show flake outputs"
            echo "  nixpkgs-fmt .      # Format all Nix files"
          '';
        };

        # Packages
        packages = {
          # Add any packages here
        };

        # Apps
        apps = {
          # Add any apps here
        };

        # Formatter
        formatter = pkgs.nixpkgs-fmt;
      }
    );
}
