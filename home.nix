{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "kenota";
  home.homeDirectory = "/Users/kenota";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";

  # Additional packages
  home.packages = [
    pkgs.jq
    pkgs.fzf
    pkgs.wget
    pkgs.youtube-dl
    pkgs.encfs
    pkgs.niv
  ];

  programs.git = {
    enable = true;
    userName = "Egor Ermakov";
    userEmail = "unplaced@gmail.com";
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      gruvbox
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      if [ -e /Users/kenota/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/kenota/.nix-profile/etc/profile.d/nix.sh; fi;
    '';

    oh-my-zsh = {
      enable = true;
    };
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.2.0";
          sha256 = "1gfyrgn23zpwv1vj37gf28hf5z0ka0w5qm6286a7qixwv7ijnrx9";
        };
      }
    ];
  };
}
