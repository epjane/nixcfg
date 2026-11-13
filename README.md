# NixCfg

## Initial Setup

Start with a fresh install of [NixOS](https://nixos.org/download/#nixos) (Graphical, 64-bit Intel/AMD)

```bash
nix-shell -p git --command 'git clone https://codeberg.org/epjane/nixcfg ~/git/epjane/nixcfg'
#look in /etc/nixos/configuration.nix for stateVersion and boot.initrd.luks.devices
#change stateVersion in flake.nix to match
#change boot.initrd.luks.devices in configuration.nix to match
#copy /etc/nixos/hardware-configuration.nix to hardware-configuration.nix
sudo nixos-rebuild switch --flake ~/git/epjane/nixcfg
```

## Manual Setup

The above installs most things, but some software stil requires manual configuration, such as GUI configs and secrets.

### signal-desktop
scan the QR code with phone and log in

### nextcloud-client
log in
set sync dir to ~/nextcloud (instead of ~/Nextcloud)
settings -> general -> launch on system startup
settings -> advanced -> move removed files to trash

### saber
log in with nextcloud

### mullvad
log in
set location
vpn settings:
  launch on startup
  auto-connect
  wireguard
user interface settings:
  start minimized

.config/Mullvad\ VPN/gui_settings.json
.config/autostart/mullvad-vpn.desktop -> /run/current-system/sw/share/applications/mullvad-vpn.desktop

### firefox
duckduckgo
disable telemetry
side tabs
adnauseam

### ssh

```bash
ssh-keygen -f ~/.ssh/confuzer
ssh-copy-id -i ~/.ssh/confuzer.pub confuzer
ssh-copy-id -i ~/.ssh/confuzer.pub refuzer

ssh-keygen -f ~/.ssh/git
```

Copy the `git.pub` key to Codeberg, Sourcehut, and Github.

### gpg key

```bash
gpg --import secret-key.asc
gpg --edit-key jane@vandymail.com
> trust
choose 5 = I trust ultimately
> save
go to https://keyoxide.org/78B26686BE1E4EBADA12C2FB26661099501A7F7D
download the key
gpg --import ~/Downloads/78B26686BE1E4EBADA12C2FB26661099501A7F7D.asc
(optional) see keyoxide proofs locally:
gpg --edit-key jane@vandymail.com
> list
> uid 1
> showpref
```


## Upgrade

### 25.05 to 26.05

Check the current channel versions:

```bash
sudo nix-channel --list
nix-channel --list
```

Add the new channel:

```bash
sudo nix-channel --add https://channels.nixos.org/nixos-26.05 nixos
sudo nix-channel --update
```

```bash
nix-instantiate --eval -E '(import <nixpkgs> {}).lib.version'
```

Edit `configuration.nix` (don't nixos-rebuild switch after!) and replace:

```nix
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;
```

with:

```nix
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz;
```

Update the channel and build without switching:

```bash
sudo nix-channel --update
sudo nixos-rebuild build
```

Make sure the build succeeds, then switch to it:

```bash
sudo nixos-rebuild switch
```

Verify that the versions are updated:

```bash
sudo nix-channel --list
nix-channel --list
```

Update home manager:

```bash
nix-shell -p home-manager --command 'home-manager switch'
```

Resolve any warnings or changed config paths and rebuild, until everthing is fixed.

### Migrate to Flakes

<https://phip1611.de/blog/migrate-stock-nixos-configuration-to-flake/>

```bash
cd ~/git/epjane/nixcfg
nix flake init --extra-experimental-features nix-command --extra-experimental-features flakes
#edit flake.nix (not shown here because it's in the repo)
nix flake update --extra-experimental-features nix-command --extra-experimental-features flakes
sudo nixos-rebuild switch --flake ~/git/epjane/nixcfg
sudo nix-channel --remove nixos
sudo rm /etc/nixos -rf
rm ~/.config/home-manager/ -rf
```

Add `nix.settings.experimental-features = "nix-command flakes";` to configuration.nix

Now home-manager rebuilds are managed as part of the flake rebuild, and configured to share nixpkgs with the system.

## TODO

### Terminal

Touchscreen scroll on terminal

### Steam

Install Steam and test some games

### Reaper

Try Reaper DAW with USB MIDI keyboard and get the latency to be low with realtime kernel

### OBS Studio

### Sound Recording

Try to record desktop audio with Audacity, or install a sound recorder app

### Syncthing

### midi

```bash
mkdir -p ~/.config/wireplumber/wireplumber.conf.d/
echo 'node.features.audio.control-port: true' > ~/.config/wireplumber/wireplumber.conf.d/my-midi.conf
```

### AirVPN

Replace MullvadVPN with AirVPN

### Paths

Find a way to replace absolute paths to this repo (`~/git/epjane/nixcfg/foo`) with relative ones (`./foo`).
Used to work before switching to flakes, but now the `./` path is inside the nix store copy instead of the actual dir.

### per-host configs

Using flakes, define different configs for different machines, giving each a folder with configuration.nix, hardware-configuration.nix, home.nix, etc.

### Modules

Break out individual software into modules, for example:
 * reaper and music plugins
 * zsh setup
 * mimetypes
 * gpg
 * git
 * ssh
 * dconf
 * keyboard mapping
 * musnix and pipewire
 * libinput-gestures and ydotool (or wtype or dotool)
