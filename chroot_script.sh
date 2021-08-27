#!/bin/bash
source config.sh

# Installing some useful packages
pacman nano

# Time zone
echo "Setting time zone"
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

echo "Generating /etc/adjtime"
hwclock --systohc

# Localization
echo "Generating locales"
sed -i 's/#de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/g' /etc/locale.gen
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen

# Creating locale.conf
localectl set-locale LANG=de_DE.UTF-8

# Keyboard layout
echo KEYMAP=$KEYMAP > /etc/vconsole.conf

# Network configuration

# Hostname file
echo $HOSTNAME > /etc/hostname

# Hosts
cat << EOF >> /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   $HOSTNAME.localdomain   $HOSTNAME
EOF

# Root password (user input)
echo "Enter root password"
passwd

# Adding user
useradd -m $USER
echo "Enter user password"
passwd $USER

# Assing user to groups
usermod -aG wheel,audio,video,optical,storage $USER

# Installing some packages
pacman -S sudo nano

# Configuring sudo
EDITOR=nano visudo

# Downloading and installing GRUB
echo "Installing GRUB"
pacman -S grub efibootmgr dosfstools os-prober mtools

mkdir /boot/EFI
mount /dev/sda1 /boot/EFI
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
grub-mkconfig -o /boot/grub/grub.cfg

# Post-installation
pacman -S networkmanager
systemctl enable NetworkManager
