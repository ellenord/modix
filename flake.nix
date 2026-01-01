{
  description = "A template for creating repositories with Nix modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    {
      # Template for creating a new repository with modules
      templates = {
        default = {
          path = ./template;
          description = "A basic template for a repository with Nix modules";
        };
        
        module-repo = {
          path = ./template;
          description = "Template for creating a repository with reusable Nix modules";
        };
      };

      # Flake schema version
      nixosModules = {
        # Example module that can be imported by other flakes
        default = import ./modules;
      };

      # Default output for the flake itself
      overlays.default = final: prev: {
        # Add any packages or overlays here
      };
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # Development shell for working with this flake
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nix
            git
            nixpkgs-fmt
          ];
          
          shellHook = ''
            echo "Modix - Nix Module Repository Template"
            echo "======================================="
            echo ""
            echo "Available commands:"
            echo "  nix flake init -t github:ellenord/modix  # Initialize a new module repository"
            echo "  nix flake show                           # Show flake outputs"
            echo "  nixpkgs-fmt ./**/*.nix                   # Format Nix files"
            echo ""
          '';
        };

        # Formatter for nix files
        formatter = pkgs.nixpkgs-fmt;
      }
    );
}
