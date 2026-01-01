{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.example;
in
{
  options.example = {
    enable = mkEnableOption "example module";

    package = mkOption {
      type = types.package;
      default = pkgs.hello;
      description = "The package to use for this example module.";
    };

    settings = mkOption {
      type = types.attrs;
      default = { };
      description = "Configuration settings for the example module.";
      example = literalExpression ''
        {
          key = "value";
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    # Add your module configuration here
    environment.systemPackages = [ cfg.package ];
  };
}
