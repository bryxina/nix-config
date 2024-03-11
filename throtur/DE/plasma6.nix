{ config, pkgs, ... }:

{
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
    desktopManager = {
      plasma6.enable = true;
    };
    displayManager = { 
      sddm.enable = true;
    };
  };

  # qt = {
  #   enable = true;
  #   platformTheme = "gnome";
  #   style = "adwaita-dark";
  # };

}