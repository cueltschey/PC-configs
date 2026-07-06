{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
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

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users."charles" = {
    isNormalUser = true;
    description = "charles";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  home-manager = {
    users = {
      "charles" = import ./home.nix;
    };
  };

  environment.systemPackages = with pkgs; [
    bash
    vim
    git
    curl
    ripgrep
    wget
    foot
    rofi
    swaybg
    #swayidle
    #swaylock
    waybar
    grim
    pkgs.sway-contrib.grimshot
    wf-recorder
    slurp
    jq
    chromium
    librewolf
    gh
    tldr
    neovim
    gcc
    cmake
    binutils
    docker
    pulseaudio
    pipewire
    wireplumber
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}
