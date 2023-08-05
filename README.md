# nixos
My NixOS configuration

## Installation instructions
1. Download the minimal NixOS ISO image from https://nixos.org/download.html#nixos-iso
2. Boot into the NixOS installer.
3. Run `sudo su` to obtain root privileges.
4. If necessary, change the keyboard layout (e.g. `loadkeys de` for german qwertz layout).
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
    lvcreate -L '200G' -n nix nixos    # nix store
    lvcreate -L '200G' -n data nixos   # persistent user data
    lvcreate -L '200G' -n cache nixos  # persistent cache
    lvcreate -L '16G' -n swap nixos    # swap
    lvcreate -L '4G' -n tmp nixos      # only used for installation
    ```
9. Format and mount LVM volumes:
    ```bash
    mkfs.ext4 /dev/nixos/tmp
    mount -m /dev/nixos/tmp /mnt

    mkfs.ext4 /dev/nixos/nix
    mkfs.ext4 /dev/nixos/data
    mkfs.ext4 /dev/nixos/cache
    mount -m /dev/nixos/nix /mnt/nix
    mount -m /dev/nixos/data /mnt/persistent/data
    mount -m /dev/nixos/cache /mnt/persistent/cache

    mkswap /dev/nixos/swap
    swapon /dev/nixos/swap
    ```
10. Format and mount EFI system partition:
    ```bash
    mkfs.fat -F32 /dev/EFI_PARTITION
    mount -m /dev/EFI_PARTITION /mnt/boot
    ```
11. Generate a temporary NixOS configuration:
    ```bash
    nixos-generate-config --root /mnt
    ```
12. Adjust the configuration in `/mnt/etc/nixos/configuration.nix`:
    ```nix
    {
      nix.settings.experimental-features = ["nix-command" "flakes"];
      boot.initrd.luks.devices.root = {
        device = "LUKS_PARTITION";
        preLVM = true;
      };
      networking.hostName = "HOSTNAME";
      environment.systemPackages = with pkgs; [
        vim
        git
      ];
    }
    ```
13. Install the temporary system and reboot:
    ```bash
    nixos-install
    reboot
    ```
14. Clone this repository:
    ```bash
    mkdir -p /persistent/data/home/felix
    cd /persistent/data/home/felix
    git clone https://github.com/Defelo/nixos.git
    cd nixos
    ```
15. Create a new host and set the user password:
    ```bash
    nix run .#new-host
    ```
16. Add new host to git:
    ```bash
    git add --intent-to-add hosts/HOSTNAME
    ```
17. Install the age private key:
    ```bash
    mkdir -p /persistent/data/root/.config/sops/age/
    cp -a keys.txt /persistent/data/root/.config/sops/age/

    mkdir -p /persistent/data/home/felix/.config/sops/age/
    mv keys.txt /persistent/data/home/felix/.config/sops/age/
    ```
18. Initialize persistent directories:
    ```bash
    mkdir -p /persistent/data/var/log
    mkdir -p /persistent/cache/var/lib/nixos

    mkdir -p /persistent/data/home/felix/.gnupg -m 700
    chown -R 1000:100 /persistent/data/home/felix
    ```
19. Install the system and reboot:
    ```bash
    ulimit -n 65536  # increase number of open files limit
    nixos-rebuild boot --flake .
    reboot
    ```
20. Remove the temporary LVM volume:
    ```bash
    sudo lvremove nixos/tmp
    ```
21. Add the new host's age key to global secrets:
    ```bash
    find secrets -type f -exec sops updatekeys -y {} \;
    ```
22. Setup yubico-pam:
    ```bash
    sudo mkdir /persistent/cache/yubico-pam -m 777
    nix shell nixpkgs#yubico-pam --command ykpamcfg -2 -v -p /persistent/cache/yubico-pam
    sudo chown -R root:root /persistent/cache/yubico-pam
    sudo chmod 700 /persistent/cache/yubico-pam
    ```
