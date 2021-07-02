ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

hwclock --systohc

pacman nano

sed -i 's/#de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen

echo KEYMAP="de-latin1 " > /etc/vconsole.conf

echo "archlinux" > /etc/hostname

cat << EOF >> /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   archlinux.localdomain   archlinux
EOF

passwd
a

useradd -m tetra
passwd tetra
a

usermod -aG wheel,audio,video,optical,storage tetra

pacman -S sudo
