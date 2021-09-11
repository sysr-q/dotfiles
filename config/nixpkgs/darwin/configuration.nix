# vim: ts=2 shiftwidth=2 expandtab
{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
      aria2
      coreutils
      curl
      ffmpeg
      git
      htop
      iperf3
      jq
      keychain
      mediainfo
      mosh
      neovim
      nmap
      nomad
      qrencode
      tmux
      tree
      vault
      wget

      python39
      python39Packages.pip
      python39Packages.sh
    ];

  # GUI apps to install some day:
  # iterm2

  homebrew.enable = true;
  # homebrew.cleanup = uninstall;
  # homebrew.global.brewfile = true;
  # homebrew.global.noLock = true;
  homebrew.masApps = {
		Amphetamine = 937984704;
		Colibri = 1178295426;
		Cyberduck = 409222199;
		Discovery = 1381004916;
		Gestimer = 990588172;
		MusicTagEditor5 = 1262758352;
		Serial = 877615577;
		Unarchiver = 425424353;
		WireGuard = 1451685025;
  };


  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Recreate /run/current-system symlink after boot
  services.activate-system.enable = true;

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  programs.fish.enable = true;

  nixpkgs.config.allowUnfree = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
