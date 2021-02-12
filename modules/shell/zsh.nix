{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.zsh;
in {
  options.modules.shell.zsh = with types; {
    enable = mkBoolOpt false;

    aliases = mkOpt (attrsOf (either str path)) {};

    rcInit = mkOpt' lines "" ''
      Zsh lines to be written to $XDG_CONFIG_HOME/zsh/extra.zshrc and sourced by
      $XDG_CONFIG_HOME/zsh/.zshrc
    '';
    envInit = mkOpt' lines "" ''
      Zsh lines to be written to $XDG_CONFIG_HOME/zsh/extra.zshenv and sourced
      by $XDG_CONFIG_HOME/zsh/.zshenv
    '';

    rcFiles  = mkOpt (listOf (either str path)) [];
    envFiles = mkOpt (listOf (either str path)) [];
  };

  config = mkIf cfg.enable {
    users.defaultUserShell = pkgs.zsh;

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      # I init completion myself, because enableGlobalCompInit initializes it
      # too soon, which means commands initialized later in my config won't get
      # completion, and running compinit twice is slow.
      enableGlobalCompInit = false;
      promptInit = "";
    };

    user.packages = with pkgs; [
      bat                                    # cat, but pretty
      bandwhich                              # htop, but for network
      bottom                                 # htop, but pretty
      dua                                    # du, but pretty
      exa                                    # ls, but pretty
      fd                                     # find, but fast, also I know how to use it
      fzf                                    # fuzzy finder, the original (probably not, who care)
      ht-rust                                # httpie, but rusty
      jq                                     # make JSON readable, well more readable
      killall                                # every last one of them (the processes, of course)
      navi                                   # retired from helping Link to help you suck less at bash
      nix-zsh-completions                    # nix zsh completions, literally
      pastel                                 # a color picker in a terminal ? Genius.
      procs                                  # ps, but pretty
      (ripgrep.override {withPCRE2 = true;}) # grep, but fast
      skim                                   # fzf, but rusty
      starship                               # a prompt theme, but I can explain why it's a mess
      tealdeer                               # yeah, I need all the help; tldr but rusty
      tokei                                  # need to know how many lines of poorly written code you typed ?
      watchexec                              # watch, then exec; run commands when a file changes
      wmctrl
      zoxide
      zsh
    ];

    env = {
      ZDOTDIR     = "$XDG_CONFIG_HOME/zsh";
      ZSH_CACHE   = "$XDG_CACHE_HOME/zsh";
      ZGEN_DIR    = "$XDG_DATA_HOME/zsh";
      ZGEN_SOURCE = "$ZGEN_DIR/zgen.zsh";
    };

    home.configFile = {
      # Write it recursively so other modules can write files to it
      "zsh" = { source = "${configDir}/zsh"; recursive = true; };

      # Why am I creating extra.zsh{rc,env} when I could be using extraInit?
      # Because extraInit generates those files in /etc/profile, and mine just
      # write the files to ~/.config/zsh; where it's easier to edit and tweak
      # them in case of issues or when experimenting.
      "zsh/extra.zshrc".text =
        let aliasLines = mapAttrsToList (n: v: "alias ${n}=\"${v}\"") cfg.aliases;
        in ''
           # This file was autogenerated, do not edit it!
           ${concatStringsSep "\n" aliasLines}
           ${concatMapStrings (path: "source '${path}'\n") cfg.rcFiles}
           ${cfg.rcInit}

           # zoxide
           eval "$(zoxide init zsh --cmd=c --hook prompt)"
           # starship
           eval "$(starship init zsh)"
        '';

      "zsh/extra.zshenv".text = ''
        # This file is autogenerated, do not edit it!
        ${concatMapStrings (path: "source '${path}'\n") cfg.envFiles}
        ${cfg.envInit}
      '';

      "starship.toml".source = "${configDir}/starship/starship.toml";

    };

    system.userActivationScripts.cleanupZgen = "rm -fv $XDG_CACHE_HOME/zsh/*";
  };
}
