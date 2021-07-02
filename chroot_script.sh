ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

hwclock --systohc

pacman nano

sed -i 's/#de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/g' /etc/locale.gen
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen

echo KEYMAP="de-latin1 " > /etc/vconsole.conf

echo "archlinux" > /etc/hostname

cat << EOF >> /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   archlinux.localdomain   archlinux
EOF

passwd

useradd -m tetra
passwd tetra

usermod -aG wheel,audio,video,optical,storage tetra

pacman -S sudo nano

EDITOR=nano visudo

pacman -S grub efibootmgr dosfstools os-prober mtools

mkdir /boot/EFI

mount /dev/sda1 /boot/EFI

grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
grub-mkconfig -o /boot/grub/grub.cfg

pacman -S networkmanager

systemctl enable NetworkManager
