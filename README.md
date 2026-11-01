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
launch on startup
auto-connect
wireguard

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
```

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

Determine if I need to upgrade from 25.05 to 26.05

### midi

```bash
mkdir -p ~/.config/wireplumber/wireplumber.conf.d/
echo 'node.features.audio.control-port: true' > ~/.config/wireplumber/wireplumber.conf.d/my-midi.conf
```

### AirVPN

Replace MullvadVPN with AirVPN
