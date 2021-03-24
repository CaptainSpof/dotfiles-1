{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.git;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.git = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      gitAndTools.gh
      gitAndTools.git-open
      gitAndTools.delta
      (mkIf config.modules.shell.gnupg.enable
        gitAndTools.git-crypt)
    ];

    home.configFile = {
      "git/config".source = "${configDir}/git/config";
      "git/ignore".source = "${configDir}/git/ignore";
      "git/attributes".source = "${configDir}/git/attributes";
    };

    modules.shell.zsh.rcFiles = [ "${configDir}/git/aliases.zsh" ];
  };
}
