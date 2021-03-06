{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.touchegg;
    configDir = config.dotfiles.configDir;
in {
  options.modules.services.touchegg = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      touchegg  # one day, we'll have touchpad gestures with smooth animations and easy configuration… But for now I have touchégg
    ];

    # FIXME: the derivation already provide this service file. I need to figure out how to enable it.
    systemd.services.touchegg = {
      enable = true;
      description = "Touchégg. The daemon.";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        Group = "input";
        Restart = "on-failure";
        RestartSec = 5;
        ExecStart = "${pkgs.touchegg}/bin/touchegg --daemon";
      };
    };

    # REVIEW: Don't need that, xdg/autostart does that for us.
    # But I noticed touchegg segfaulting on some occasions.
    # This service restart it when it happen.
    systemd.user.services.touchegg-client = {
      description = "Touchégg. The client.";

      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      serviceConfig = {
        Restart = "on-failure";
        ExecStart = "${pkgs.touchegg}/bin/touchegg";
      };
    };

    home.configFile = {
      "touchegg/touchegg.conf" = {
        source = "${configDir}/touchegg/touchegg.conf";
        recursive = true;
      };
    };
  };
}
