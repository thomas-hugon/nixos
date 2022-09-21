nixos.org/manual/nixos/stable/


```bash
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

#format
mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
mkfs.fat -F 32 -n boot /dev/sda3


...

```
