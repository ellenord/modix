# Modix - Nix Module Repository Template

A Nix flake template for creating repositories with reusable Nix modules.

## Quick Start

### Using the Template

Create a new repository with this template:

```bash
nix flake init -t github:ellenord/modix
```

Or use a specific template:

```bash
nix flake init -t github:ellenord/modix#module-repo
```

### Development

Enter the development environment:

```bash
nix develop
```

## Features

- **Flake-based**: Modern Nix flakes configuration
- **Module structure**: Pre-configured structure for NixOS modules
- **Development shell**: Includes useful tools for working with Nix
- **Example module**: A complete example to get you started
- **Best practices**: Follows Nix community conventions

## Template Structure

The template creates a repository with:

- `flake.nix`: Flake configuration with proper inputs and outputs
- `modules/`: Directory for your Nix modules
- `modules/default.nix`: Module exports
- `modules/example.nix`: Example module showing the structure
- `.gitignore`: Pre-configured for Nix projects
- `README.md`: Documentation for the generated repository

## Using Modules from This Template

Once you've created a repository with this template, others can use your modules:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    your-modules.url = "github:yourusername/yourrepo";
  };

  outputs = { self, nixpkgs, your-modules, ... }: {
    nixosConfigurations.hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        your-modules.nixosModules.default
        # or specific modules:
        # your-modules.nixosModules.example
      ];
    };
  };
}
```

## License

MIT