[![Made with Doom Emacs](https://img.shields.io/badge/Made_with-Doom_Emacs-blueviolet.svg?style=flat-square&logo=GNU%20Emacs&logoColor=white)](https://github.com/hlissner/doom-emacs)
[![NixOS 21.05](https://img.shields.io/badge/NixOS-v21.05-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

**Hey,** you. You're finally awake. You were trying to configure your OS declaratively, right? Walked right into that NixOS ambush, same as us, and those dotfiles over there.

**Hey,** you. Did you get lost in your fork journey? It's alright, I've been there. Just note that I'm gently going with the nix waves, learning along (it's a pretty boring metaphore to say: I don't really know what I am doing. So beware.)


For now, I've tried to replicate my previous Arch installation. It's based on plasma. 

I've added an [overlay](overlays/touchegg.nix) for [touchégg](https://github.com/JoseExposito/touchegg) (touchpad gestures). Hopefully I haven't messed it up too much.

I've added a [derivation](packages/lightly-qt5.nix) for the qt theme "[Lightly](https://github.com/Luwx/Lightly)".

I've added a bunch of apps and modules that I used and some that I wish I didn't. Configuration for said apps is really scarce (damn you plasma, you're qt and all, but your configuration setup is a mess...) 

I've failed to add an overlay for [krohnkite](https://github.com/esjeon/krohnkite) (a tilling window manager plugins for plasma), I had to install it manually. (it works on my machine, I know, insult and injury yadiyada for a nixos config)

Next in line is to continue to make sense out of nix, learn some nixops stuff (didn't quite figure out how to remotely build a configuration, maybe nixops will help).
I'd like to setup a few raspberry pi with nix and maybe nix containers.

<img src="/../screenshots/alucard/fakebusy.png" width="100%" />
<p align="center">
<span><img src="/../screenshots/alucard/desktop.png" height="178" /></span>
<span><img src="/../screenshots/alucard/rofi.png" height="178" /></span>
<span><img src="/../screenshots/alucard/tiling.png" height="178" /></span>
</p>
⬆ not mine, I use a white theme, as such I fear the Internet brigade will hunt me down if I post my own.

------

| | |
|-|-|
| **Shell:** | zsh + zgen |
| **DM:** | sddm |
| **DE/WM:** | plasma + [krohnkite](https://github.com/esjeon/krohnkite) |
| **Editor:** | [Doom Emacs][doom-emacs] (and occasionally [vim]) |
| **Terminal:** | alacritty |
| **Launcher:** | rofi + krunner |
| **Browser:** | firefox |
| **GTK Theme:** | Breeze |
| **Qt Theme:** | [Lightly](https://github.com/Luwx/Lightly) |

-----

## Quick start

1. Yoink the latest build of [NixOS 21.05][nixos].
2. Boot into the installer.
3. Do your partitions and mount your root to `/mnt` ([for example](hosts/dafbox/README.org))
4. Install these dotfiles:
5. `nix-shell -p git nixFlakes`
6. `git clone https://github.com/CaptainSpof/dotfiles /mnt/etc/nixos`
7. Install NixOS: `nixos-install --root /mnt --flake /mnt/etc/nixos#XYZ`, where
   `XYZ` is [the host you want to install](hosts/).  Use `#generic` for a
   simple, universal config, or create a sub-directory in `hosts/` for your device. See [host/dafbox] for an example.

Alternatively if you're getting:
`access to path /mnt/nix/store/[...] is forbidden in restricted mode.`

install with:
``` sh
nix-shell -p nixUnstable
nix build /mnt/etc/nixos#nixosConfigurations.<HOSTNAME>.config.system.build.toplevel --experimental-features "flakes nix-command" --store "/mnt" --impure
# then install the build system...
nixos-install --root /mnt --system ./result
```
8. Reboot!
9. Change your `root` and `$USER` passwords!

## Management

And I say, `bin/hey`. [What's going on?](http://hemansings.com/)

```
Usage: hey [global-options] [command] [sub-options]

Available Commands:
  check                  Run 'nix flake check' on your dotfiles
  gc                     Garbage collect & optimize nix store
  generations            Explore, manage, diff across generations
  help [SUBCOMMAND]      Show usage information for this script or a subcommand
  rebuild                Rebuild the current system's flake
  repl                   Open a nix-repl with nixpkgs and dotfiles preloaded
  rollback               Roll back to last generation
  search                 Search nixpkgs for a package
  show                   [ARGS...]
  ssh HOST [COMMAND]     Run a bin/hey command on a remote NixOS system
  swap PATH [PATH...]    Recursively swap nix-store symlinks with copies (or back).
  test                   Quickly rebuild, for quick iteration
  theme THEME_NAME       Quickly swap to another theme module
  update [INPUT...]      Update specific flakes or all of them
  upgrade                Update all flakes and rebuild system

Options:
    -d, --dryrun                     Don't change anything; preform dry run
    -D, --debug                      Show trace on nix errors
    -f, --flake URI                  Change target flake to URI
    -h, --help                       Display this help, or help for a specific command
    -i, -A, -q, -e, -p               Forward to nix-env
```

## Frequently asked questions

+ **Why NixOS?**

  Because declarative, generational, and immutable configuration is a godsend
  when you have a fleet of computers to manage.
  
+ **How do you manage secrets?**

  With [agenix].
  
+ **How do I change the default username?**

  1. Set the `USER` environment variable the first time you run `nixos-install`:
     `USER=myusername nixos-install --root /mnt --flake /path/to/dotfiles#XYZ`
  2. Or change `"daf"` in modules/options.nix.
  
+ **Why did you write bin/hey?**

  I envy Guix's CLI and want similar for NixOS, but its toolchain is spread
  across many commands, none of which are as intuitive: `nix`,
  `nix-collect-garbage`, `nixos-rebuild`, `nix-env`, `nix-shell`.
  
  I don't claim `hey` is the answer, but everybody likes their own brew.
 
+ **How 2 flakes?**

  Would it be the NixOS experience if I gave you all the answers in one,
  convenient place?
  
  No. Suffer my pain:
  
  + [A three-part tweag article that everyone's read.](https://www.tweag.io/blog/2020-05-25-flakes/)
  + [An overengineered config to scare off beginners.](https://github.com/nrdxp/nixflk)
  + [A minimalistic config for scared beginners.](https://github.com/colemickens/nixos-flake-example)
  + [A nixos wiki page that spells out the format of flake.nix.](https://nixos.wiki/wiki/Flakes)
  + [Official documentation that nobody reads.](https://nixos.org/learn.html)
  + [Some great videos on general nixOS tooling and hackery.](https://www.youtube.com/channel/UC-cY3DcYladGdFQWIKL90SQ)
  + A couple flake configs that I 
    [may](https://github.com/LEXUGE/nixos) 
    [have](https://github.com/bqv/nixrc)
    [shamelessly](https://git.sr.ht/~dunklecat/nixos-config/tree)
    [rummaged](https://github.com/utdemir/dotfiles)
    [through](https://github.com/purcell/dotfiles).
  + [Some notes about using Nix](https://github.com/justinwoo/nix-shorts)
  + [What helped me figure out generators (for npm, yarn, python and haskell)](https://myme.no/posts/2020-01-26-nixos-for-development.html)
  + [What y'all will need when Nix drives you to drink.](https://www.youtube.com/watch?v=Eni9PPPPBpg)


[doom-emacs]: https://github.com/hlissner/doom-emacs
[vim]: https://github.com/hlissner/.vim
[nixos]: https://releases.nixos.org/?prefix=nixos/unstable/
[host/dafbox]: https://github.com/CaptainSpof/dotfiles/tree/master/hosts/dafbox
[agenix]: https://github.com/ryantm/agenix
