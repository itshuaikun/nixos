{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  nix.settings.trusted-users = [ "root" "sk" ];
  nix.settings.experimental-features = ["nix-command" "flakes"];
  networking.networkmanager.enable = true;
  programs.clash-verge = {
    enable = true;
    package = pkgs.clash-verge-rev;
    serviceMode = true;
    autoStart = true;
  };
  time.timeZone = "Asia/Shanghai";

  hardware.bluetooth.enable = true;
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      qt6Packages.fcitx5-qt
      qt6Packages.fcitx5-chinese-addons
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";

  programs.fish.enable = true;
  users.users.sk = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    initialPassword = " ";
    shell = pkgs.fish;
  };
  security.sudo.wheelNeedsPassword = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [ "openssl-1.1.1w" ];
  environment.systemPackages = with pkgs; [
    vim
    wget
    fastfetch
    clash-verge-rev
    btop
    libreoffice-fresh
    git
    gcc gnumake cmake
    qt6Packages.fcitx5-configtool
    fish
    kitty
    filezilla
    nomachine-client
    typora
    qq
    wechat
    nur.repos.xddxdd.dingtalk
    telegram-desktop
    brave
    vscode
    stm32cubemx
    dsview
    unstable.cc-switch
    unstable.codex
  ];
  environment.variables.EDITOR = "vim";
  programs.kdeconnect.enable = true;
  programs.git = {
    enable = true;
    config = {
      user.name = "sk";
      user.email = "pi3l4l5q2b@gmail.com";
      credential.helper = "store";
    };
  };

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  system.stateVersion = "26.05";
}
