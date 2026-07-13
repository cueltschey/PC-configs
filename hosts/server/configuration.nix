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
    allowedTCPPorts = [ 22 80 443 ];
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "chaseuelt@gmail.com";
    certs."cueltschey.com".domain = "cueltschey.com";
  };

  security.sudo.wheelNeedsPassword = true;

  # GNOME Keyring for secretspec secret storage (headless server)
  # The module handles dbus service files and PAM for 'login'.
  # sshd PAM integration is needed since there's no graphical login.
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sshd.enableGnomeKeyring = true;

  system.stateVersion = "26.05";
}
