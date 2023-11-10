# nixos
My NixOS configuration

## Installation instructions
1. Download the minimal NixOS ISO image from https://nixos.org/download.html#nixos-iso
2. Boot into the NixOS installer.
3. Run `sudo su` to obtain root privileges.
4. If necessary, change the keyboard layout (e.g. `loadkeys de-latin1` for german qwertz layout).
5. Connect to the internet.
6. Use `fdisk` or `cfdisk` to create a GPT partition table with the following partitions:
    - `/dev/EFI_PARTITION`: EFI system partition (type: EFI System, size: 512M)
    - `/dev/LUKS_PARTITION`: Encrypted root partition (type: Linux filesystem)
7. Create and open the LUKS container:
    ```bash
    cryptsetup -yv luksFormat /dev/LUKS_PARTITION
    cryptsetup open /dev/LUKS_PARTITION root
    ```
8. Create LVM volumes (adjust volume sizes):
    ```bash
    pvcreate /dev/mapper/root
    vgcreate nixos /dev/mapper/root
    lvcreate -L '256G' -n nix nixos          # nix store
    lvcreate -L '256G' -n persistent nixos   # persistent user data/cache
    lvcreate -L '16G' -n swap nixos          # swap
    ```
9. Format and mount LVM volumes:
    ```bash
    mount -m -t tmpfs -o size=4G,mode=755 tmpfs /mnt

    mkfs.btrfs /dev/nixos/nix
    mount -m -o compress=zstd,noatime /dev/nixos/nix /mnt/nix

    mkfs.btrfs /dev/nixos/persistent
    mount -m /dev/nixos/persistent /mnt/persistent
    btrfs subvolume create /mnt/persistent/@data
    btrfs subvolume create /mnt/persistent/@data/.snapshots
    btrfs subvolume create /mnt/persistent/@cache
    btrfs subvolume create /mnt/persistent/@cache/.snapshots
    umount /mnt/persistent
    mount -m -o compress=zstd,noatime,subvol=@data /dev/nixos/persistent /mnt/persistent/data
    mount -m -o compress=zstd,noatime,subvol=@cache /dev/nixos/persistent /mnt/persistent/cache

    mkswap /dev/nixos/swap
    swapon /dev/nixos/swap
    ```
10. Format and mount EFI system partition:
    ```bash
    mkfs.fat -F32 /dev/EFI_PARTITION
    mount -m /dev/EFI_PARTITION /mnt/boot
    ```
11. Enable flakes on the live system and install git:
    ```bash
    mkdir -p ~/.config/nix/
    echo experimental-features = nix-command flakes > ~/.config/nix/nix.conf
    nix profile install nixpkgs#git
    ```
12. Clone this repository:
    ```bash
    mkdir -p /mnt/persistent/data/home/felix/
    cd /mnt/persistent/data/home/felix/
    git clone https://github.com/Defelo/nixos.git
    cd nixos
    ```
13. Create a new host and set the user password:
    ```bash
    nix run .#new-host HOSTNAME
    ```
14. Add new host to git:
    ```bash
    git add --intent-to-add hosts/HOSTNAME
    ```
15. Install the base system and reboot:
    ```bash
    nixos-install --flake .#HOSTNAME-base --no-channel-copy --no-root-passwd
    reboot
    ```
16. Install age private key and initialize persistent directories:
    ```bash
    cd /persistent/data/home/felix/nixos/
    nix run .#setup-host
    ```
17. Install the system and reboot:
    ```bash
    ulimit -n 65536  # increase number of open files limit
    nixos-rebuild boot --flake .
    reboot
    ```
18. Add the new host's age key to global secrets:
    ```bash
    find secrets -type f -exec sops updatekeys -y {} \;
    ```
19. Setup pam-u2f:
    ```bash
    nix shell nixpkgs#pam_u2f --command pamu2fcfg | sudo tee /persistent/cache/u2f_keys
    sudo chown root:users /persistent/cache/u2f_keys
    sudo chmod 640 /persistent/cache/u2f_keys
    ```
