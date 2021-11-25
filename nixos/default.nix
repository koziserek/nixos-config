# Dustin's NixOS configuration
{ config, inputs, pkgs, ... }:
{
  imports = [
    ../common
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.blacklistedKernelModules = [ "mt76x2u" ];

  # Set your time zone.
  time.timeZone = "America/New_York";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.hostName = "felix"; # Define your hostname.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;

  # Turn on flag for proprietary software
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;
  nix = {
    allowedUsers = [ "dustin" ];
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };

  # GTK Native Comp Emacs
  services.emacs.package = pkgs.emacsPgtkGcc;
  services.emacs.enable = true;
  nixpkgs.overlays = [
    (import (builtins.fetchGit {
      url = "https://github.com/nix-community/emacs-overlay.git";
    }))
  ];

  # Video games, patch libusb1 so Xbox controller works
  programs.steam.enable = true;
  nixpkgs.config.packageOverrides = pkgs: {
    xow = pkgs.xow.overrideAttrs (orig: {
      version = "pre-1.0.25";
      buildInputs = [ inputs.libusb.packages.x86_64-linux.libusb ];
    });
  };

  # Enable the X11 windowing system
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.screenSection = ''
    Option       "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
    Option       "AllowIndirectGLXProtocol" "off"
    Option       "TripleBuffer" "on"
  '';

  # Enable the GNOME Desktop Environment
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Turn Caps Lock into Ctrl
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "ctrl:nocaps";

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.driSupport = true;
  services.hardware.xow.enable = true;
  services.udev.packages = [ pkgs.xow ];

  # libinput provides better support for our stuff
  services.xserver.libinput.enable = true;
  boot.kernelModules = [ "uinput" ];

  # Sync state between machines
  services.syncthing = {
    enable = true;
    user = "dustin";
    dataDir = "/home/dustin/.config/syncthing";
    configDir = "/home/dustin/.config/syncthing";
  };

  # It's me
  users.users.dustin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # NixOS trivia. Q: What is the difference between
  # systemPackages and regular user profile packages?
  # A: systemPackages are updated every time the system is rebuilt
  environment.systemPackages = with pkgs; [
    xow
    (emacsWithPackagesFromUsePackage {
      config = ../common/config/emacs/Emacs.org;
      package = emacsPgtkGcc;
      alwaysEnsure = true;
    })
  ];

  system.stateVersion = "21.05"; # Don't change this

}
