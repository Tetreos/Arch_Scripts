#!/bin/bash
source config.sh
# Pre-installation --------------------------------------------------------------------------------------------------

# Load the right Keymap
echo "Setting the keyboard layout"
loadkeys $KEYMAP

# Verify the boot mode
# If the command shows the directory without error, then the system is booted in UEFI mode
# If the directory does not exist, the system may be booted in BIOS (or CSM) mode
echo "Verifying the boot mode"
echo "If the command shows the directory without error, then the system is booted in UEFI mode"
echo "If the directory does not exist, the system may be booted in BIOS (or CSM) mode"
ls /sys/firmware/efi/efivars
sleep 5

# Connect to the internet
# Not necessary when Ethernet
# TO-DO Wi-Fi

# Update the system clock
echo "Updating the system clock"
timedatectl set-ntp true

# TO-DO -----------------------------------
# Partition the disk /dev/sda
echo "Partitioning the disk /dev/sda"
(
echo g
echo n # Add a new partition
echo 1 # Partition number
echo   # First sector (Accept default: 1)
echo +550M
echo t
echo 1
echo n # Add a new partition
echo 2 # Partition number
echo   # First sector (Accept default: 1)
echo +4G
echo t
echo 2
echo 19
echo n # Add a new partition
echo 3 # Partition number
echo   # First sector (Accept default: 1)
echo 
echo w # Write changes
) | fdisk /dev/sda
# TO-DO -----------------------------------

# Format the partitions
echo "Ext4 file system on /dev/sda"
mkfs.ext4 /dev/sda3

echo "Initializing swap"
mkswap /dev/sda2

mkfs.fat -F32 /dev/sda1

# Mounting the file systems
echo "Mounting root volume sda3"
mount /dev/sda3 /mnt

echo "Enabling swap"
swapon /dev/sda2

# Installation ------------------------------------------------------------------------------------------------------

# Select the mirrors
# TO-DO

# Installing essential packages
pacstrap /mnt base linux linux-firmware

# Configure the system ----------------------------------------------------------------------------------------------

# Generating fstab file
echo "Generating fstab file"
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot
echo "Chroot"
cp chroot_script.sh /mnt
cp config.sh /mnt

read -n 1 -s -r -p "Press any key to continue"

arch-chroot /mnt

# After Chroot

rm /mnt/chroot_script.sh
rm /mnt/config.sh
umount -l /mnt
