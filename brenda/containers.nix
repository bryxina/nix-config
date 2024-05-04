{ config, pkgs, lib, ... }:

{
systemd.user.services.unifi = {
    enable = true;
    description = "unifi-pod";
    after = [ "network-online.target" "basic.target" ];
    environment = {
        HOME = "/home/apinter";
        LANG = "en_US.UTF-8";
        USER = "apinter";
    };
    path = [ 
        "/run/wrappers"
        pkgs.podman
        pkgs.bash
        pkgs.conmon
        pkgs.crun
        pkgs.slirp4netns
        pkgs.su
        pkgs.shadow
        pkgs.fuse-overlayfs
        config.virtualisation.podman.package
    ];
    unitConfig = {
    };
    serviceConfig = {
        Type = "oneshot";
        TimeoutStartSec = 900;
        ExecStartPre = lib.mkBefore [
        "-${pkgs.podman}/bin/podman pod rm unifi-pod"
        "-${pkgs.podman}/bin/podman pull --authfile=/home/apinter/.secret/auth.json docker.io/library/mongo:7"
        "-${pkgs.podman}/bin/podman pull --authfile=/home/apinter/.secret/auth.json lscr.io/linuxserver/unifi-network-application:latest"
        ];
        ExecStart = "${pkgs.podman}/bin/podman kube play /home/apinter/kube/unifi.yml";
        ExecStop = "${pkgs.podman}/bin/podman pod stop unifi-pod";
        ExecStopPost = "${pkgs.podman}/bin/podman pod rm unifi-pod";
        RemainAfterExit = true;
    };
    wantedBy = [ "default.target" ];
};


}