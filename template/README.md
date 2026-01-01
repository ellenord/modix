# Nix Module Repository

This repository contains reusable Nix modules that can be used in NixOS configurations or other Nix projects.

## Usage

### As a NixOS Module

Add this flake to your NixOS configuration:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    my-modules.url = "github:yourusername/yourrepo";
  };

  outputs = { self, nixpkgs, my-modules }:
    {
      nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          my-modules.nixosModules.default
          ./configuration.nix
        ];
      };
    };
}
```

### Available Modules

- `example`: An example module demonstrating the basic structure

## Development

Enter the development shell:

```bash
nix develop
```

## Adding New Modules

1. Create a new `.nix` file in the `modules/` directory
2. Add the module export to `modules/default.nix`
3. Update the `nixosModules` section in `flake.nix`

## Module Structure

Each module should follow this basic structure:

```nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.yourmodule;
in
{
  options.yourmodule = {
    enable = mkEnableOption "your module";
    
    # Add your options here
  };

  config = mkIf cfg.enable {
    # Add your configuration here
  };
}
```

## License

MIT (or your preferred license)
