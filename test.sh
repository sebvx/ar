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
localectl set-locale ru_UA.UTF-8
hwclock --systohc

#pacman
sed 's/Architecture = auto/Architecture = auto \n ILoveCandy/g' -i /etc/pacman.conf
sed 's/#ParallelDownloads = 5/ParallelDownloads = 10/g' -i /etc/pacman.conf
sed 's/#Color/Color/g' -i /etc/pacman.conf
pacman -Sy --noconfirm reflector

reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
#Настройк Grub загрузчика системы
#grub-install --target=i386-pc --recheck /dev/sda
#grub-mkconfig -o /boot/grub/grub.cfg
#Отключение заплаток intel
pacman -S --noconfirm --needed reflector git rsync curl lrzip unrar unzip unace p7zip squashfs-tools
#Alsa
pacman -S alsa alsa-utils alsa-firmware alsa-card-profiles alsa-plugins
#Video
pacman -S --noconfirm mesa lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader
#CPU
pacman -S --noconfirm intel-ucode 
#настройка mkinit
mkinitcpio -P
sed 's/BINARIES=()/BINARIES=(btrfs)/g' -i /etc/mkinitcpio.conf
sed 's/#COMPRESSION="zstd"/COMPRESSION="zstd"/g' -i /etc/mkinitcpio.conf
sed 's/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet rootfstype=btrfs mitigations=off nowatchdog"/g' -i /etc/default/grub
grub-install --target=i386-pc --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# ускорение
mkdir /home/seb/tools
cd /home/seb/tools
# zramswap
git clone https://aur.archlinux.org/zramswap.git  # Скачивание исходников.
cd zramswap                                       # Переход в zramswap.
makepkg -sric                                     # Сборка и установка.
systemctl enable --now zramswap.service      # Включаем службу.
echo "ZRAM_COMPRESSION_ALGO=zstd" | tee -a /etc/zramswap.conf
#Nohang
cd /home/seb/tools
git clone https://aur.archlinux.org/nohang-git.git # Скачивание исходников.
cd nohang-git                                      # Переход в nohang-git
makepkg -sric                                      # Сборка и установка.
systemctl enable --now nohang-desktop  		       # Включаем службу.
#ananicy-cpp
cd /home/seb/tools
git clone https://aur.archlinux.org/ananicy-cpp.git # Скачивание исходников.
cd ananicy-cpp                                      # Переход в ananicy-cpp.
makepkg -sric                                       # Сборка и установка.
systemctl enable --now ananicy-cpp             		# Включаем службу.
cd /home/seb/tools
git clone https://aur.archlinux.org/ananicy-rules-git.git # Скачивание исходников
cd ananicy-rules-git                                      # Переход в директорию
makepkg -sric                                             # Сборка и установка
systemctl restart ananicy-cpp                     		   # Перезапускаем службу
#dbus-broker
pacman -S dbus-broker                         # Уставновка
systemctl enable --now dbus-broker.service    # Включает и запускает службу.
systemctl --global enable dbus-broker.service # Включает и запускает службу для всех пользователей.




# проги доп
pacman -Sy --noconfirm --needed  bat  docker docker-compose  gping tldr fd glances
echo "alias cat='bat' " >> ~/.bashrc
echo "alias ll='ls -lah --color=auto' " >> ~/.bashrc
echo "alias la='ls -la --color=auto' " >> ~/.bashrc
echo "alias grep='grep --colour=auto' " >> ~/.bashrc
echo "alias ping='gping' " >> ~/.bashrc
echo "alias man='tldr' " >> ~/.bashrc
#echo "alias find='fd' " >> ~/.bashrc
echo "alias top='glances' " >> ~/.bashrc
echo "alias htop='glances' " >> ~/.bashrc




# KDE
pacman -S --needed xorg sddm plasma-desktop plasma-wayland-session breeze-gtk kde-gtk-config

pacman -Rsn kwayland-integration kwallet-pam plasma-thunderbolt plasma-vault powerdevil plasma-sdk kgamma5 drkonqi discover oxygen bluedevil plasma-browser-integration plasma-firewall

sudo pacman -Rsn plasma-pa     # Удаляем виджет управления звуком.
sudo pacman -S kmix            # Замена виджету plasma-pa, совместим с ALSA.
systemctl --user mask kde-baloo.service           # Полное отключение
systemctl --user mask plasma-baloorunner.service


# pacman -S kitty vim stacer neofetch btop ark p7zip unrar qbittorent guvcview slimjet
#Добавление сервисов в автоpагрузку


systemctl enable NetworkManager sshd sddm docker 
systemctl mask NetworkManager-wait-online.service

#grub-install --target=i386-pc --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg


echo "Enter reboot now"

exit
