# modules/desktop/vm/virt-manager.nix
#

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.vm.virt-manager;
in {
  options.modules.desktop.vm.virt-manager = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {

    virtualisation.libvirtd.enable = true;

    environment.systemPackages = with pkgs; [
      virt-manager
    ];

    user.extraGroups = [ "libvirtd" ];
  };
}
