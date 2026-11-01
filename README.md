# NixCfg

## Initial Setup

Start with a fresh install of [NixOS](https://nixos.org/download/#nixos) (Graphical, 64-bit Intel/AMD)

```bash
mkdir -p ~/git/epjane
cd ~/git/epjane
nix-shell -p git --command 'git clone https://codeberg.org/epjane/nixcfg'
cd nixcfg
sudo rm /etc/nixos/configuration.nix
sudo ln -s $(pwd)/configuration.nix /etc/nixos/configuration.nix
sudo nixos-rebuild switch

mkdir -p ~/.config/home-manager/
ln -s $(pwd)/home.nix ~/.config/home-manager/home.nix
nix-shell -p home-manager --command 'home-manager switch'
```

## Manual Setup

The above installs most things, but some software stil requires manual configuration, such as GUI configs and secrets.

### nextcloud-client
log in
set sync dir to ~/nextcloud (instead of ~/Nextcloud)
settings -> launch on system startup

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


## TODO

### shortcuts

Set up aliases for editing nixos and hm configs:

```bash
sudo nano /etc/nixos/configuration.nix; sudo nixos-rebuild switch
nano ~/.config/home-manager/home.nix; nix-shell -p home-manager --command 'home-manager switch'
```

### upgrade

Upgrade from 25.05 to 26.05, needed for some new packages

### gnome gestures

Patch to differentiate between 3 and 4 finger gestures

See: https://codeberg.org/epjane/dotfiles/src/branch/main/roles/gnome-settings

### gnome extensions

Might need 3/4 finger gesture extension

See: https://codeberg.org/epjane/dotfiles/src/branch/main/roles/gnome-extensions

### midi

```bash
mkdir -p ~/.config/wireplumber/wireplumber.conf.d/
echo 'node.features.audio.control-port: true' > ~/.config/wireplumber/wireplumber.conf.d/my-midi.conf
```

### AirVPN

Replace MullvadVPN with AirVPN
