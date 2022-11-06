#!/bin/bash
#Разкоментрируем русскую локаль
sed '/ru_RU.UTF-8 UTF-8/s/^#//' -i /etc/locale.gen
echo "LANG=ru_RU.UTF-8" >> /etc/locale.conf
#установка шрифта для консоли
echo "KEYMAP=ru" >> /etc/vconsole.conf
echo "FONT=cyr-sun16 " >> /etc/vconsole.conf
#Установка таймзоны
ln -s /usr/share/zoneinfo/Europe/Kiev /etc/localtime
#Имя hostname
echo "localhost" >> /etc/hostname
echo "127.0.1.1 localhost" >> /etc/hosts
locale-gen
localectl set-locale ru_RU.UTF-8
hwclock --systohc
#настройка mkinit
sed 's/BINARIES=()/BINARIES=(btrfs)/g' -i /etc/mkinitcpio.conf
sed 's/#COMPRESSION="zstd"/COMPRESSION="zstd"/g' -i /etc/mkinitcpio.conf
#pacman
sed 's/Architecture = auto/Architecture = auto \n ILoveCandy/g' -i /etc/pacman.conf
sed 's/#ParallelDownloads = 5/ParallelDownloads = 10/g' -i /etc/pacman.conf
sed 's/#Color/Color/g' -i /etc/pacman.conf
reflector --latest 15 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
#Настройк Grub загрузчика системы
#grub-install --target=i386-pc --recheck /dev/sda
#grub-mkconfig -o /boot/grub/grub.cfg
#Отключение заплаток intel
sed 's/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet rootfstype=btrfs mitigations=off nowatchdog"/g' -i /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg



# проги доп
pacman -Syy --noconfirm --needed  bat alsa-utils docker docker-compose ananicy-cpp ananicy-rules-git dbus-broker zramswap gping tldr fd glances
echo "alias cat='bat' " >> /.bashrc
echo "alias ll='ls -lah --color=auto' " >> ~/.bashrc
echo "alias la='ls -la --color=auto' " >> ~/.bashrc
echo "alias grep='grep --colour=auto' " >> ~/.bashrc
echo "alias ping='gping' " >> ~/.bashrc
echo "alias man='tldr' " >> ~/.bashrc
#echo "alias find='fd' " >> ~/.bashrc
echo "alias top='glances' " >> ~/.bashrc
echo "alias htop='glances' " >> ~/.bashrc


echo "ZRAM_COMPRESSION_ALGO=zstd" | sudo tee -a /etc/zramswap.conf

# KDE
pacman -S --noconfirm --needed xorg sddm plasma kde-applications slimjet
echo "Current=breeze" >> /usr/lib/sddm/sddm.conf.d/default.conf





#pacman -S --noconfirm --needed kitty vim stacer neofetch btop ark p7zip unrar qbittorent guvcview slimjet
#Добавление сервисов в автоpагрузку


systemctl enable NetworkManager sshd sddm docker ananicy-cpp dbus-broker zramswap
systemctl mask NetworkManager-wait-online.service
systemctl --global enable dbus-broker.service
systemctl start docker


#docker
echo'docker volume create portainer_data'
echo"docker run -d -p 8000:8000 -p 9443:9443 --name=portainer --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer-ce:latest"



echo "Enter reboot now"

exit
