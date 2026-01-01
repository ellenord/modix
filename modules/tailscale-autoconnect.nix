{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.tailscale-autoconnect;
in
{
  options.services.tailscale-autoconnect = {
    enable = lib.mkEnableOption "automatic Tailscale authentication and connection";

    authKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/keys/tailscale-authkey"; # or config.sops.secrets.tailscale-key.path
      description = ''
        Path to the file containing authkey (one-time or reusable).
        Recommended to use from sops-nix: config.sops.secrets."tailscale-key".path
      '';
    };

    extraUpFlags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "--advertise-exit-node"
        "--accept-dns"
        "--ssh"
      ];
      description = "Additional flags for tailscale up";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.authKeyFile != null;
        message = "services.tailscale-autoconnect.authKeyFile must be set (for example, from sops-nix)";
      }
    ];

    services.tailscale.enable = true;

    networking.firewall = {
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };

    systemd.services.tailscale-autoconnect = {
      description = "Automatic Tailscale connection";
      requires = [
        "network-online.target"
        "tailscaled.service"
      ];
      after = [
        "network-online.target"
        "tailscaled.service"
      ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script =
        let
          tailscaleCmd = "${config.services.tailscale.package}/bin/tailscale";
        in
        ''
          # If already connected, do nothing
          if ${tailscaleCmd} status --json | grep -q '"BackendState":"Running"'; then
            exit 0
          fi

          # Connect with authkey (tailscale will ignore if already authorized)
          ${tailscaleCmd} up \
            --auth-key=file:${cfg.authKeyFile} \
            ${lib.escapeShellArgs cfg.extraUpFlags}
        '';
    };
    systemd.timers.tailscale-autoconnect = {
      description = "Timer for tailscale autoconnect";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "1min";
        Unit = "tailscale-autoconnect.service";
      };
    };
  };
}
