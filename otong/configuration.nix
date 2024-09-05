{ config, pkgs, callPackage, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./monitoring/node-exporter.nix
      ./systemd-user/flatpak-auto-update.nix
      ./hardware/accel.nix
      ./system/garbagecollect.nix
      ./system/autoupgrade.nix
      ./DE/plasma6.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.kernelModules = [ "amdgpu" ];
  security.rtkit.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  networking.hostName = "otong";
  networking.networkmanager.enable = true;
  zramSwap.enable = true;

  time.timeZone = "Asia/Jakarta";

  users.users.nathan = {
    initialPassword = "pw123";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  users.users.apinter = {
    isNormalUser = true;
    linger = true;
    home = "/home/apinter";
    description = "Attila Pinter";
    extraGroups = [ "wheel" "devops" "podman" "docker"];
    openssh.authorizedKeys.keys = [ 
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAINYgL/PMWtjixH8gzkXuuU03GcgdXFNXfX42HuFGGoHGAAAABHNzaDo= tw.kazeshini-30-03-2024-adathor-yubikeyA" 
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIEGr9vLSNBrHSY2RwFHpkXWSCGPtvRqxgVLKduww+1FAAAAABHNzaDo= tw.kazeshini-30-03-2024-adathor-yubikeyC" 
    ];
  };
  security.sudo.extraRules = [
    {
      groups = [ "devops" ];
      commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
    }
  ];

  users.groups.devops.gid = 5000;

  environment.systemPackages = with pkgs; [
    ark
    zip
    unzip
    bash
    vim
    wget
    curl
    ranger
    git
    firefox
    policycoreutils
    python3
    distrobox
    xorg.xhost
    conmon
    crun
    slirp4netns
    su
    mesa
    glxinfo
    wineWowPackages.stable
    winetricks
    gnome-disk-utility
    gnome-keyring
    kdePackages.kdeconnect-kde
    microsoft-edge
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };
  };
  virtualisation.oci-containers.backend = "podman";
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
  services.fstrim.enable = true;
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.sane-backends ];
  networking.firewall.enable = false;
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" ];
  };

  fileSystems."/home/nathan/Common" = {
      device = "172.168.1.3:/shirayuki/Common";
      fsType = "nfs";
  };

  fileSystems."/home/nathan/Reno" = {
      device = "172.168.1.3:/shirayuki/Home/nathan";
      fsType = "nfs";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;  
  system.stateVersion = "23.05";
}