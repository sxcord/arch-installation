#! /usr/bash

# installation part


# configuration part
iwctl
device wlan0 set-property Powered on
station wlan0 scan
exit
iwctl --passphrase=a16111939 station wlan0  connect "D-Link 5"

# the time
timedatectl Africa/Algiers

# make partitions here
sudo fdisk /dev/sda << EOF
p
n
1

+1G
t
1
w
EOF

sudo fdisk /dev/sda << EOF
n
2

+10G
w
EOF

sudo fdisk /dev/sda << EOF
n
3


w
EOF

#format the partitions
mkfs.ext4 /dev/sda3
mkswap /dev/sda1
mkfs.fat -F 32 /dev/sda1

# mount the partitions
mount /dev/sda3 /mnt
mount --mkdir /dev/sda1 /mnt/boot
swapon /dev/sda2

# install essential packages
pacstrap -K /mnt base linux linux-firmware base-devel sof-firmware vim neovim  nano man-db man-pages texinfo git python3 github firefox vlc mpv rofi htop alacritty neofetch grub os-prober efibootmgr dosfstools mtools gptfdisk fatresize geany zip

genfstab -U /mnt >> /mnt/etc/fstab

# chroot
arch-chroot /mnt

# time zone 
ln -sf /usr/share/zoneinfo/Africa/Algiers /etc/localtime
hwclock --systohc

#localization
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
sed -i "171d" /etc/locale.gen
sed -i "171iLANG=en_US.UTF-8 UTF-8" /etc/locale.gen
sed -i "35d" /etc/locale.conf
sed -i "35iLANG=ar_DZ.UTF-8 UTF-8" /etc/locale.conf
locale-gen

# uncommand Edit /etc/locale.gen and uncomment en_US.UTF-8 UTF-8locale-gen
echo "LANG=en_US.UTF-8 UTF-8" > /etc/locale.conf
echo "KEYMAP=de-latin1" >  /etc/vconsole.conf
echo "archlinux" > /etc/hostname

mkinitcpio -P

# hosts file ( check )
echo '127.0.0.1	localhost
::1		localhost
127.0.1.1	archlinux' > /etc/hosts
# set root password
password

# users and groups
useradd -m sxcord -s /bin/bash -G wheel -p ""
cd /home/sxcord/
mkdir -p Desktop Downloads/{yay,"git clone",garbage}/ Projects/{"C++","Python","SQL","Bash"}/ Books/ "Movies & Series"/ Games/ Wallpapers/ /Videos/Courses/
# mirrors ( check )
pacman -Syy
pacman -Sy reflector
cd /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
reflector -c "DZ" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist

# boot loader
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --efi-directory=/boot/efi --recheck
grub-mkconfig -o /boot/grub/grub.cfg

# end of insatlling arch linux


# insall yay and other packages
cd /opt/
sudo git clone https://aur.archlinux.org/yay.git
chown -R sxcord:scord yay-git/
cd yay-git/
echo y | makepkg -si # as sxcord user

su sxcord
cd Downloads/yay/
sudo yay -S
exit
# end



# font
cd /usr/local/share/fonts/
mkdir JetBrainsMono FiraCode Hack IBM_Plex_Mono
wget -P /usr/local/share/fonts/JetBrainsMono/ -O JetBrainsMonoFonts.zip
wget -P /usr/local/share/fonts/Hack/ https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip
wget -P /usr/local/share/fonts/FiraCode -O FiraCode.zip https://fonts.google.com/download?family=Fira%20Code
wget -P /usr/local/share/fonts/IBM_Plex_Mono -O IBM_Plex_Mono.zip https://fonts.google.com/download?family=IBM%20Plex%20Mono
unzip -u IBM_Plex_Mono/IBM_Plex_Mono.zip 
unzip -u FiraCode/FiraCode.zip
unzip -u Hack/Hack-v3.003-ttf.zip
unzip -u JetBrainsMono/JetBrainsMonoFonts.zip
rm IBM_Plex_Mono/IBM_Plex_Mono.zip FiraCode/FiraCode.zip Hack/Hack-v3.003-ttf JetBrainsMono/JetBrainsMonoFonts.zip

cd /usr/local/share/fonts/IBM_PLex_Mono 
rm IBMPlexMono-{BoldItalic,Extr*,Thi*,BoldItal*,Ligh*}.ttf
cd ../

cd JetBrainsMono/fonts/ttf
mkdir temp; mv JetBrainsMono-{Bold,ExtraBold,Italic,Light,Regular,SemiBold,SemiBoldItalic,light}.ttf temp; rm *; mv temp/* .; rmdir temp;
cd ../../
echo "adding fonts completed"

# configure geany
cd /home/sxcord/.config/geany/
git clone https://github.com/geany/geany-themes
cd geany-themes/; chmod 777 install.sh;
./install.sh

# terminal aka alacritty
cd /home/sxcord/
mv .bahsrc /home/sxcord/
mv alacritty.yml /home/sxcord/.config/alacritty/
mkdir /home/sxcord/.config/starship; mv starship.toml /home/sxcord/.config/starship.yoml
curl -sS https://starship.rs/install.sh | sh # install starship
# echo 'eval "$(starship init bash)"' >> /home/sxcord/.bashrc

# anime cli
yay -S ani-cli --noconfirm




exit # exit chroot

umount -R /mnt
echo "Installation ended, reboot $hostname"

