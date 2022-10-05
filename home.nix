{ config, pkgs, lib, ... }:

rec {
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

  nixpkgs.overlays = [ (import ./apps-overlay.nix) ];

  # This enables symlinking of the applications installed via Nix home 
  # manager to ~/Applications/Nix. See https://github.com/nix-community/home-manager/issues/1341 for
  # more details. 
  # Credit for code: https://github.com/ldeck/nix-home 
  home.activation = {
    aliasApplications = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      app_folder=$(echo ${home.homeDirectory}/Applications/Nix)
      mkdir -p $app_folder

      IFS=$'\n'
      old_paths=($(mdfind kMDItemKind="Alias" -onlyin "$app_folder"))
      new_paths=($(find "$newGenPath/home-path/Applications" -name '*.app' -type l))
      unset IFS

      old_size="''${#old_paths[@]}"
      echo "removing $old_size aliased apps from $app_folder"
      for i in "''${!old_paths[@]}"; do
        $DRY_RUN_CMD rm -f "''${old_paths[$i]}"
      done

      new_size="''${#new_paths[@]}"
      echo "adding $new_size aliased apps into $app_folder"

      for i in "''${!new_paths[@]}"; do
        real_app=$(realpath "''${new_paths[$i]}")
        app_name=$(basename "''${new_paths[$i]}")
        $DRY_RUN_CMD rm -f "$app_folder/$app_name"
        $DRY_RUN_CMD osascript \
          -e "tell app \"Finder\"" \
          -e "make new alias file at POSIX file \"$app_folder\" to POSIX file \"$real_app\"" \
          -e "set name of result to \"$app_name\"" \
          -e "end tell"
      done
    '';
  };
  

  # Additional packages
  home.packages = [
    pkgs.jq
    pkgs.fzf
    pkgs.wget
#    pkgs.youtube-dl
    pkgs.encfs
    pkgs.niv
    pkgs.git
    pkgs.git-lfs
    pkgs.yarn
    pkgs.hugo
    pkgs.nodejs-14_x
    pkgs.silver-searcher
    pkgs.Anki
    pkgs.Obsidian
    pkgs.Gnucash
    pkgs.nginx
    pkgs.cargo

    # Go
    pkgs.go_1_15
    pkgs.gopkgs
    pkgs.go-outline
    pkgs.gotests
    pkgs.gomodifytags
    pkgs.impl
    pkgs.delve
    pkgs.gopls
    pkgs.golangci-lint

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
