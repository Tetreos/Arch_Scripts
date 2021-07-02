#!/bin/bash
# Arch Install

# Load the right Keymap
KEYMAP="de-latin1"
loadkeys $KEYMAP

# Systemclock
timedatectl set-ntp true

# Drive
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

mkfs.fat -F32 /dev/sda1

mkswap /dev/sda2
swapon /dev/sda2

mkfs.ext4 /dev/sda3

mount /dev/sda3 /mnt
pacstrap /mnt base linux linux-firmware

genfstab -U /mnt >> /mnt/etc/fstab

cp chroot_script.sh /mnt

arch-chroot /mnt

rm /mnt/chroot_script.sh

umount -l /mnt
