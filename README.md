nixos.org/manual/nixos/stable/


```bash
#boot sur live usb

##partitionnement
# partition gpt
parted /dev/sda -- mklabel gpt
# partition primaire sans les premiers 512Mb (partition boot) ni les derniers 8Gb (SWAP) 
parted /dev/sda -- mkpart primary 512MB -8GB
# partition swap 8gb
parted /dev/sda -- mkpart primary linux-swap -8GB 100%
# partition EFI de 1Mb a 512Mb pour /boot 
parted /dev/sda -- mkpart ESP fat32 1MB 512MB
# partition 3 (/boot) est bootable
parted /dev/sda -- set 3 esp on

#format + labels
mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
mkfs.fat -F 32 -n boot /dev/sda3


#on monte les partitions créées
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
# si pas assez de ram pour l'installeur nixos
# swapon /dev/sda2


#génération de la conf de base
nixos-generate-config --root /mnt

git clone https://github.com/thomas-hugon/nixos.git


nixos-install
...

```

si depuis autre linux
```bash
#partitions + formatage pareil + mount

curl -L https://nixos.org/nix/install | sh
. $HOME/.nix-profile/etc/profile.d/nix.sh 
nix-channel --list
# nixpkgs https://nixos.org/channels/nixpkgs-unstable
nix-channel --add https://nixos.org/channels/nixos-version nixpkgs
nix-channel --update
nix-env -f '<nixpkgs>' -iA nixos-install-tools
sudo `which nixos-generate-config` --root /mnt
# ajouter les entry grub existantes dans le configuration.nix
# exemple
# boot.loader.grub.extraEntries = ''
#  menuentry "Ubuntu" {
#    search --set=ubuntu --fs-uuid 3cc3e652-0c1f-4800-8451-033754f68e6e
#    configfile "($ubuntu)/boot/grub/grub.cfg"
#  }
#'';

#group et user nixbld sur linux existant
sudo groupadd -g 30000 nixbld
sudo useradd -u 30000 -g nixbld -G nixbld nixbld

#install -> ATTENTION conf grub niquée, ne démarre peut-être plus en l'état
sudo PATH="$PATH" NIX_PATH="$NIX_PATH" `which nixos-install` --root /mnt

#plus besoin du user et group de build
sudo userdel nixbld
sudo groupdel nixbld

```
