# nixos
My NixOS configuration

## Installation instructions
1. Boot the [minimal NixOS ISO image](https://nixos.org/download.html#nixos-iso)
2. Create a GPT partition table with the following partitions:
    - `/dev/EFI_PARTITION`: EFI system partition (type: EFI System, size: 1G)
    - `/dev/LUKS_PARTITION`: Encrypted root partition (type: Linux filesystem)
3. Create and open the LUKS container:
    ```bash
    cryptsetup -yv luksFormat /dev/LUKS_PARTITION
    cryptsetup open /dev/LUKS_PARTITION root
    ```
4. Create and mount btrfs subvolumes:
    ```bash
    mkfs.btrfs -f /dev/mapper/root

    mount -m -o noatime,compress=zstd /dev/mapper/root /mnt
    btrfs subvolume create /mnt/@data
    btrfs subvolume create /mnt/@data/.snapshots
    btrfs subvolume create /mnt/@cache
    btrfs subvolume create /mnt/@cache/.snapshots
    btrfs subvolume create /mnt/@nix
    btrfs subvolume create /mnt/@swap
    umount /mnt

    mount -m -o size=100%,mode=755 -t tmpfs tmpfs /mnt
    mount -m -o noatime,compress=zstd,subvol=@data /dev/mapper/root /mnt/persistent/data
    mount -m -o noatime,compress=zstd,subvol=@cache /dev/mapper/root /mnt/persistent/cache
    mount -m -o noatime,compress=zstd,subvol=@nix /dev/mapper/root /mnt/nix
    mount -m -o noatime,compress=zstd,subvol=@swap /dev/mapper/root /mnt/swap
    ```
5. Create and activate swapfile:
    ```bash
    btrfs filesystem mkswapfile -s 16G /mnt/swap/swapfile
    btrfs inspect-internal map-swapfile -r /mnt/swap/swapfile  # resume_offset
    swapon /mnt/swap/swapfile
    ```
6. Format and mount EFI system partition:
    ```bash
    mkfs.vfat /dev/EFI_PARTITION
    mount -m -o umask=0077 /dev/EFI_PARTITION /mnt/boot
    ```
7. Install git:
    ```bash
    nix-env -iA nixos.git
    ```
8. Clone this repository:
    ```bash
    mkdir -p /mnt/persistent/data/home/felix/
    cd /mnt/persistent/data/home/felix/
    git clone https://github.com/Defelo/nixos.git
    cd nixos
    ```
9. Create a new or modify an existing host (don't forget to add new files to git).
10. Install the system and reboot:
    ```bash
    nixos-install --flake .#HOSTNAME --no-channel-copy --no-root-password
    reboot
    ```
