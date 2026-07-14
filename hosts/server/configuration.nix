{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "server";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  users.users."charles" = {
    isNormalUser = true;
    description = "charles";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
  };

  users.users."deploy" = {
    isNormalUser = true;
    description = "deploy";
    extraGroups = [ "docker" ];
    packages = with pkgs; [];
    shell = pkgs.bash;
  };

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
    storageDriver = "overlay2";
  };

  home-manager = {
    users = {
      "charles" = import ./home.nix;
    };
  };

  environment.systemPackages = with pkgs; [
    bash
    git
    vim
    neovim
    curl
    wget
    rsync
    htop
    tmux
    jq
    ripgrep
    docker-compose
    dive
    skopeo
    gh
    secretspec
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
      MaxAuthTries = 3;
      LoginGraceTime = 30;
    };
  };

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "10m";
    ignoreIP = [ "127.0.0.1/8" "::1" ];
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 22000 ];
    allowedUDPPorts = [ 22000 21027 ];
  };

  # Certbot with DNS-01 challenge via IONOS API (supports wildcard certs)
  systemd.tmpfiles.rules = [
    "d /var/lib/certbot 0755 root root -"
  ];

  systemd.services.certbot-obtain = {
    description = "Obtain SSL certificate for cueltschey.com + wildcard";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      EnvironmentFile = "/var/lib/certbot/ionos-env";
      ExecStart = pkgs.writeShellScript "certbot-obtain" ''
        export PATH="${pkgs.certbot}/bin:${pkgs.curl}/bin:${pkgs.jq}/bin:$PATH"

        # Get IONOS zone ID
        ZONE_ID=$(curl -sf -X GET "https://api.hosting.ionos.com/dns/v1/zones" \
          -H "X-API-Key: ''${IONOS_API_KEY}" \
          -H "Content-Type: application/json" | \
          jq -r '.items[] | select(.name == "cueltschey.com") | .id')

        if [ -z "$ZONE_ID" ]; then
          echo "ERROR: Could not find zone cueltschey.com"
          exit 1
        fi

        certbot certonly --manual \
          --preferred-challenges dns \
          -d "cueltschey.com" -d "*.cueltschey.com" \
          --manual-auth-hook ${pkgs.writeShellScript "certbot-auth-hook" ''
            export PATH="${pkgs.curl}/bin:${pkgs.jq}/bin:$PATH"
            ZONE_ID=$(curl -sf -X GET "https://api.hosting.ionos.com/dns/v1/zones" \
              -H "X-API-Key: ''${IONOS_API_KEY}" \
              -H "Content-Type: application/json" | \
              jq -r '.items[] | select(.name == "cueltschey.com") | .id')
            curl -sf -X POST "https://api.hosting.ionos.com/dns/v1/zones/$ZONE_ID/records" \
              -H "X-API-Key: ''${IONOS_API_KEY}" \
              -H "Content-Type: application/json" \
              -d "{\"name\":\"_acme-challenge\",\"type\":\"TXT\",\"content\":\"''${CERTBOT_VALIDATION}\",\"ttl\":300}"
            sleep 15
          ''} \
          --manual-cleanup-hook ${pkgs.writeShellScript "certbot-cleanup-hook" ''
            export PATH="${pkgs.curl}/bin:${pkgs.jq}/bin:$PATH"
            ZONE_ID=$(curl -sf -X GET "https://api.hosting.ionos.com/dns/v1/zones" \
              -H "X-API-Key: ''${IONOS_API_KEY}" \
              -H "Content-Type: application/json" | \
              jq -r '.items[] | select(.name == "cueltschey.com") | .id')
            RECORD_ID=$(curl -sf -X GET "https://api.hosting.ionos.com/dns/v1/zones/$ZONE_ID/records" \
              -H "X-API-Key: ''${IONOS_API_KEY}" \
              -H "Content-Type: application/json" | \
              jq -r '.items[] | select(.name == "_acme-challenge" and .type == "TXT") | .id')
            [ -n "$RECORD_ID" ] && \
              curl -sf -X DELETE "https://api.hosting.ionos.com/dns/v1/zones/$ZONE_ID/records/$RECORD_ID" \
                -H "X-API-Key: ''${IONOS_API_KEY}"
          ''} \
          --agree-tos -m "chaseuelt@gmail.com" \
          --non-interactive \
          --config-dir /var/lib/certbot \
          --logs-dir /var/log/certbot
      '';
    };
  };

  systemd.services.certbot-renew = {
    description = "Renew SSL certificates";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      EnvironmentFile = "/var/lib/certbot/ionos-env";
      ExecStart = pkgs.writeShellScript "certbot-renew" ''
        export PATH="${pkgs.certbot}/bin:${pkgs.curl}/bin:${pkgs.jq}/bin:$PATH"
        certbot renew \
          --config-dir /var/lib/certbot \
          --logs-dir /var/log/certbot
      '';
    };
  };

  systemd.timers.certbot-renew = {
    description = "Renew SSL certificates twice daily";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "06,18:30";
      Persistent = true;
    };
  };

  security.sudo.wheelNeedsPassword = true;

  # GNOME Keyring for secretspec secret storage (headless server)
  # The module handles dbus service files and PAM for 'login'.
  # sshd PAM integration is needed since there's no graphical login.
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sshd.enableGnomeKeyring = true;

  system.stateVersion = "26.05";
}
