{ config, pkgs, lib, ... }:

with import <nixpkgs> {};
with builtins;
with lib;
with import <home-manager/modules/lib/dag.nix> { inherit lib; };

{
  programs.home-manager.enable = true;
  home.stateVersion = "25.05";
  home.username = "user";
  home.homeDirectory = "/home/user";
  home.packages = with pkgs; [
    pinentry-gnome3

    gnomeExtensions.appindicator
    gnomeExtensions.middle-click-to-close-in-overview
#    gnomeExtensions.swap-finger-gestures-3-to-4 #requires 26.05

    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-z

    file
    wl-clipboard
    xdg-utils
    unzip
    keepassxc
    firefox
    calibre
    htop
    glances
    tmux
    jq
    arp-scan
    krita
    saber
    libreoffice
    aisleriot
    nethack
    ungoogled-chromium
    vscodium-fhs
    python3
    kdePackages.kolourpaint
    kdePackages.kdenlive
    meld
    xournalpp
    trashy
    qpwgraph
    fluidsynth
    surge-XT
    audacity
    go
    thonny
    godot
    steam-run-free
    nextcloud-client
    qbittorrent
  ];

  #https://github.com/nix-community/home-manager/issues/1439#issuecomment-1106208294
  #for some reason not needed anymore, started seeing double desktop launchers
#  home.activation = {
#    linkDesktopApplications = {
#      after = [ "writeBoundary" "createXdgUserDirectories" ];
#      before = [ ];
#      data = ''
#        rm -rf ${config.xdg.dataHome}/"applications/home-manager"
#        mkdir -p ${config.xdg.dataHome}/"applications/home-manager"
#        cp -Lr ${config.home.homeDirectory}/.nix-profile/share/applications/* ${config.xdg.dataHome}/"applications/home-manager/"
#      '';
#    };
#  };

  xdg.enable = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
    };
  };

  programs.command-not-found.enable = true;

#  services.kbfs.enable = true;

  programs.zsh.enable = true;
#  home.sessionPath = [ "${config.home.homeDirectory}/nextcloud/bin" ];
  home.sessionVariables = {
    ZSH_AUTOSUGGEST_PLUGIN =
      "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh";

    ZSH_SYNTAX_HIGHLIGHTING_PLUGIN =
      "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";

    ZSH_Z_PLUGIN =
      "${pkgs.zsh-z}/share/zsh-z/zsh-z.plugin.zsh";
  };

  home.file.".zshrc".source = config.lib.file.mkOutOfStoreSymlink ./appcfg/zshrc;
  home.file.".nethackrc".source = config.lib.file.mkOutOfStoreSymlink ./appcfg/nethackrc;
  home.file.".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink ./appcfg/tmux.conf;


  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
#    enableSshSupport = true;
#    defaultCacheTtl = 1800;
#    pinentry.package = pkgs.pinentry-tty;
    pinentry.package = pkgs.pinentry-gnome3;
    defaultCacheTtl = 3600;
    maxCacheTtl = 7200;
  };

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "Jane Vandegriff";
    userEmail = "jane@vandymail.com";

    signing = {
      format = "openpgp";
      key = "jane@vandymail.com";
#      key = "78B26686BE1E4EBADA12C2FB26661099501A7F7D";
      signByDefault = true;
    };

    extraConfig = {
      gpg.format = "openpgp";

      alias.pushall = "!git remote | xargs -L1 git push --all";

      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

  programs.ssh = {
    enable = true;

    matchBlocks = {
      "*" = {
        serverAliveInterval = 60;
        serverAliveCountMax = 3;
        compression = true;
      };

      confuzer = {
        user = "jane";
        hostname = "drive.confuzer.cloud";
        port = 2230;
        identityFile = "~/.ssh/confuzer";
      };

      refuzer = {
        user = "user";
        hostname = "refuzer.confuzer.cloud";
        port = 2231;
        identityFile = "~/.ssh/confuzer";
      };
    };
  };

  dconf.settings = {
#no error but doesn't work, used keyd in configuration.nix instead:
#    "org/gnome/desktop/input-sources/xkb-options" = {
#      value = [ "caps:ctrl_modifier" ];
#    };

    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = true;
    };

    # Disable Mouse Acceleration and set pointer speed to 3/4 the default value
    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";      # Disable mouse acceleration
      speed = 0.5;                      # Set mouse pointer speed to 3/4
    };

    # Touchpad pointer speed adjustment (same as mouse)
    "org/gnome/desktop/peripherals/touchpad" = {
      speed = 0.5;                      # Set touchpad pointer speed to 3/4
    };

    # Set GNOME Shell to Dark Mode (for both the shell and GTK apps)
    "org/gnome/desktop/interface" = {
      gtk-theme = "Adwaita-dark";  # Set GTK apps to use the dark theme
      icon-theme = "Adwaita";      # Optional: ensure icons match the dark theme
      color-scheme = "prefer-dark";  # Set the GNOME Shell to dark mode
    };

    # Set GNOME to Dark Mode
    "org/gnome/shell" = {
      gtk-theme = "Adwaita-dark";  # Change to Dark Mode theme
      disable-user-extensions = false;
      disabled-extensions = [];
      enabled-extensions = [
        pkgs.gnomeExtensions.appindicator.extensionUuid
	pkgs.gnomeExtensions.middle-click-to-close-in-overview.extensionUuid
#        pkgs.gnomeExtensions.swap-finger-gestures-3-to-4.extensionUuid
      ];
    };

    # disable suspend when plugged in and dim when idle
    "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-type = "nothing";
        idle-dim = false;
    };

    # disable automatic screen blank
    "org/gnome/desktop/session" = {
        idle-delay = lib.hm.gvariant.mkUint32 0;
    };

    # GNOME Media Keys (custom keybindings)
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/file-explorer/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gnome-disks/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/codium/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/libreoffice-writer/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/settings/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/suspend/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/keepassxc/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/calculator/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/firefox/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/firefox-private-window/"
      ];
    };

    # Terminal keybinding (Super + Return)
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal" = {
      name = "Terminal";
      command = "kgx";
      binding = "<Super>Return";
    };

    # File Explorer keybinding (Super + E)
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/file-explorer" = {
      name = "File Explorer";
      command = "nautilus";
      binding = "<Super>e";
    };

    # GNOME Disks keybinding (Super + D)
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gnome-disks" = {
      name = "GNOME Disks";
      command = "gnome-disks";
      binding = "<Super>d";
    };

    # Codium keybinding (Super + I)
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/codium" = {
      name = "Codium";
      command = "codium";
      binding = "<Super>i";
    };

    # LibreOffice Writer keybinding (Super + W)
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/libreoffice-writer" = {
      name = "LibreOffice Writer";
      command = "libreoffice --writer";
      binding = "<Super>w";
    };

    # Settings keybinding (Super + S)
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/settings" = {
      name = "Settings";
      command = "gnome-control-center";
      binding = "<Super>s";
    };

    # Suspend keybinding (Super + Alt + S)
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/suspend" = {
      name = "Suspend";
      command = "systemctl suspend";
      binding = "<Super><Alt>s";
    };

    # KeePassXC keybinding (Super + K)
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/keepassxc" = {
      name = "KeePassXC";
      command = "keepassxc";
      binding = "<Super>k";
    };

    # Calculator keybinding (Super + C)
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/calculator" = {
      name = "Calculator";
      command = "gnome-calculator";
      binding = "<Super>c";
    };

    # Firefox keybinding (Super + B)
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/firefox" = {
      name = "Firefox";
      command = "firefox";
      binding = "<Super>b";
    };

    # Firefox Private Window keybinding (Super + Alt + B)
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/firefox-private-window" = {
      name = "Firefox Private Window";
      command = "firefox --private-window";
      binding = "<Super><Alt>b";
    };

    # Unbind Super + S from opening the Quick Settings menu
    "org/gnome/shell/keybindings" = {
      toggle-quick-settings = [];  # Unbind Super + S from the Quick Settings menu
    };
 
    # Workspace switching (Super+1 to Super+0)
    "org/gnome/desktop/wm/keybindings" = {
      toggle-fullscreen = [ "<Super>backslash" ];

      switch-to-workspace-1  = [ "<Super>1" ];
      switch-to-workspace-2  = [ "<Super>2" ];
      switch-to-workspace-3  = [ "<Super>3" ];
      switch-to-workspace-4  = [ "<Super>4" ];
      switch-to-workspace-5  = [ "<Super>5" ];
      switch-to-workspace-6  = [ "<Super>6" ];
      switch-to-workspace-7  = [ "<Super>7" ];
      switch-to-workspace-8  = [ "<Super>8" ];
      switch-to-workspace-9  = [ "<Super>9" ];
      switch-to-workspace-10 = [ "<Super>0" ];

      move-to-workspace-1  = [ "<Super><Alt>1" ];
      move-to-workspace-2  = [ "<Super><Alt>2" ];
      move-to-workspace-3  = [ "<Super><Alt>3" ];
      move-to-workspace-4  = [ "<Super><Alt>4" ];
      move-to-workspace-5  = [ "<Super><Alt>5" ];
      move-to-workspace-6  = [ "<Super><Alt>6" ];
      move-to-workspace-7  = [ "<Super><Alt>7" ];
      move-to-workspace-8  = [ "<Super><Alt>8" ];
      move-to-workspace-9  = [ "<Super><Alt>9" ];
      move-to-workspace-10 = [ "<Super><Alt>0" ];
    };

    # Unbind Super+number from GNOME Shell pinned app shortcuts
    "org/gnome/shell/keybindings" = {
      switch-to-application-1  = [];
      switch-to-application-2  = [];
      switch-to-application-3  = [];
      switch-to-application-4  = [];
      switch-to-application-5  = [];
      switch-to-application-6  = [];
      switch-to-application-7  = [];
      switch-to-application-8  = [];
      switch-to-application-9  = [];
      switch-to-application-10 = [];
    };

    # Close Window using Super+X or GNOME built-in keybinding (Alt+F4)
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Alt>F4" "<Super>x" ];
    };
   
    "org/gnome/desktop/wm/preferences" = {
      focus-mode = "sloppy";
      #auto-raise = true;
    };

    "org/gnome/desktop/wm/keybindings" = {
      "switch-applications" = ["<Super>Tab"];  # Unbind the "Alt+Tab" from switching applications and use "Super+Tab instead"
      "switch-windows" = ["<Alt>Tab"];  # Bind "Alt+Tab" to switch windows
    };
  };

}
