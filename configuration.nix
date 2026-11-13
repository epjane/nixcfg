# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  # Flakes
  nix.settings.experimental-features = "nix-command flakes";

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-25fef4c3-6b56-4797-b310-302cbd9d86f2".device = "/dev/disk/by-uuid/25fef4c3-6b56-4797-b310-302cbd9d86f2";
  networking.hostName = "f12"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone
  time.timeZone = "America/New_York";

  # Select internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
#    options = "rctrl:ends,ralt:home";
  };
#  console.useXkbConfig = true;

#  services.xserver.xkbOptions = [
#  services.xserver.xkbExtraConfig = ''
#      key <RALT> {        [ Home ] };    # Change Right Alt to Home
#      key <RCTL> {        [ End ] };     # Change Right Ctrl to End
#    '';

  #https://unix.stackexchange.com/questions/377600/in-nixos-how-to-remap-caps-lock-to-control/776816#776816
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            #when pressed with another key, acts as Ctrl (e.g. Ctrl-C, Ctrl-V)
            #when pressed and released without pressing another key, acts as Esc
            capslock = "overload(control, esc)";
            rightalt = "home";
            rightcontrol = "end";
#            "meta+semicolon" = "command(/toggle-top.sh)";
          };
        };
      };
    };
  };

  # https://community.frame.work/t/enable-trim-unmap-on-the-storage-expansion-card/8885
  services.udev.extraRules = ''
    ACTION=="add|change", ATTRS{idVendor}=="13fe", ATTRS{idProduct}=="6500", SUBSYSTEM=="scsi_disk", ATTR{provisioning_mode}="unmap"
  '';

  # Enable CUPS to print documents
  services.printing.enable = true;

  #https://nixos.wiki/wiki/PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true; #allow jack applications to use pipewire
    #media-session.enable = true;
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # User account
  users.users.user = { #username is "user"
    isNormalUser = true;
    description = "Jane V.";
    extraGroups = [ "networkmanager" "wheel" "audio" "dialout" "docker" "input" "ydotool" ];
#    packages = with pkgs; [
#    ];
  };

  # musnix
  musnix.enable = true;
#  musnix.kernel.realtime = true; #this doesn't work with the intel GPU drivers (i915)
#  boot.initrd.kernelModules = lib.mkForce [ ]; #disable i915 so that musnix.kernel.realtime works
#  boot.kernelPackages = pkgs.linuxPackages-rt_latest; #this works with i915 but causes wifi to fail after sleep
#  boot.kernelPackages = pkgs.linuxPackages_rt_6_1; #this works with i915, wifi TODO #not available on 26.05
#  boot.kernelPackages = pkgs.linuxPackages_rt_5_10; #TODO try

  # Firefox
  #programs.firefox.enable = true;
  
  # Exceptions to unfree packages must be managed here since home-manager is configured to use system nixpkgs
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "SpaceCadetPinball"
    "unrar"
    "reaper"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
#    wget
    appimage-run
    # https://discourse.nixos.org/t/mounting-of-camera-not-working-gphoto2-canon-camera/24038/6
    gphoto2
    gphoto2fs

    ydotool
    libinput-gestures
  ];
  programs.gphoto2.enable = true;
  programs.ydotool.enable = true;
  services.libinput.enable = true;

  environment.sessionVariables = {
    YDOTOOL_SOCKET = "/run/ydotoold/socket";
  };

  systemd.user.services.libinput-gestures = {
    description = "Libinput Gestures";
    wantedBy = [ "default.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.libinput-gestures}/bin/libinput-gestures";
      Restart = "on-failure";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are started in user sessions
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon
  # services.openssh.enable = true;

  # Open ports in the firewall
  networking.firewall.allowedTCPPorts = [ 1623 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether:
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
  #we are on 26.05 but this needs to stay at 25.05

  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

#  virtualisation.virtualbox.host.enable = true;
#  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];

  virtualisation.docker = {
    enable = true;
  };

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
}
