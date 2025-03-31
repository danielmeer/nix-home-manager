{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "daniel";
  home.homeDirectory = "/home/daniel";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # bmap-tools # Needs sudo
    # dcfldd # Needs sudo
    distrobox
    duf
    fd
    fzf
    imagemagick
    meld
    patchelf
    podman
    ripgrep
    subversionClient
    tig
    tio
    tldr
    tree
    ubootTools

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    # nerdfonts
    # (pkgs.nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # fonts.fontconfig.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # You can also set the file content immediately.
    ".config/tig/config".text = ''
      # F4 - diff file against previous commit
      bind diff <F4> !git difftool --no-prompt %(commit)^! -- %(file)

      # F5 - diff commit against previous commit
      bind generic <F5> !git difftool --no-prompt %(commit)^!

      # F6 - diff file against previous commit
      bind diff <F6> !git difftool --tool=bc --no-prompt %(commit)^! -- %(file)
    '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/daniel/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "nvim";
    # VISUAL = "nvim";
  };

  # targets.genericLinux.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # programs.bash.enable = true;
  # xdg.mime.enable = true;
  # xdg.systemDirs.data = [ "${config.home.homeDirectory}/.nix-profile/share/applications" ];

  # programs.bash = {
  #   enable = true;
  #   profileExtra = ''
  #     export XDG_DATA_DIRS=$HOME/.home-manager-share:$XDG_DATA_DIRS
  #   '';
  # };

  # home.activation = {
  #   linkDesktopApplications = {
  #     after = [ "writeBoundary" "createXdgUserDirectories" ];
  #     before = [ ];
  #     data = ''
  #       rm -rf $HOME/.home-manager-share
  #       mkdir -p $HOME/.home-manager-share
  #       cp -Lr --no-preserve=mode,ownership ${config.home.homeDirectory}/.nix-profile/share/* $HOME/.home-manager-share
  #     '';
  #   };
  # };

  programs.bat.enable = true;

  programs.eza = {
    enable = true;
    extraOptions = [
      "--group"
      "--group-directories-first"
    ];
  };

  programs.fish = {
    enable = true;
    functions = {
      netio = "curl \"http://DaMe-Netio/netio.cgi?pass=netio&output{$argv}=4\"";
    };
    shellAliases = {
      ls = "ls --color=auto --group-directories-first";
      t = "tig --all";
      g = "git status";
      gd = "git difftool";
      gdbc = "git difftool --tool=bc";
      gitmerge = "git mergetool --tool=meld";
    };
    plugins = [
      { name = "bass"; src = pkgs.fishPlugins.bass.src; }
    ];
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "Daniel Meer";
    userEmail = "daniel.meer@speedgoat.ch";
    lfs.enable = true;
    extraConfig = {
      # Hide warning in git-svn when 'git dcommit' first pulls new updates
      advice.skippedCherryPicks = "false";
      # core.editor = "code --wait";
      credential.helper = "libsecret";
      diff = {
        guitool = "meld";
        tool = "meld";
      };
      difftool.meld.cmd = "meld $LOCAL $REMOTE";
      merge.guitool = "vscode";
      mergetool.meld.cmd = "meld --diff $LOCAL $MERGED $REMOTE --diff $BASE $LOCAL --diff $BASE $REMOTE --output $MERGED";
      mergetool.vscode.cmd = "code --wait --merge $REMOTE $LOCAL $BASE $MERGED";
      pull.rebase = "true";
    };
    # delta = {
    #   enable = true;
    #   options = {
    #     decorations = {
    #       commit-decoration-style = "bold yellow box ul";
    #       file-decoration-style = "none";
    #       file-style = "bold yellow ul";
    #     };
    #     features = "decorations";
    #   };
    # };
  };

  programs.lazygit.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
      autocmd FileType gitcommit set textwidth=80
    '';
    vimAlias = true;
  };

  programs.nnn = {
    enable = true;
    package = pkgs.nnn.override ({ withNerdIcons = true; });
  };

  programs.password-store.enable = true;
}
