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
#права судо для группы wheel
sed 's/# %wheel ALL=(ALL:ALL) ALL/ %wheel ALL=(ALL:ALL) ALL/g' -i /etc/sudoers
locale-gen
localectl set-locale ru_RU.UTF-8
hwclock --systohc
#root пароль и добавление пользователя
echo 'root pass'
passwd
read -p "Add User : " username
useradd -m -g users -G wheel -s /bin/bash $username
echo 'User pass'
passwd $username
#настройка mkinit
sed 's/BINARIES=()/BINARIES=(btrfs)/g' -i /etc/mkinitcpio.conf
sed 's/#COMPRESSION="zstd"/COMPRESSION="zstd"/g' -i /etc/mkinitcpio.conf
#pacman
sed 's/Architecture = auto/Architecture = auto \n ILoveCandy/g' -i /etc/pacman.conf
sed 's/#ParallelDownloads = 5/ParallelDownloads = 10/g' -i /etc/pacman.conf
sed 's/#Color/Color/g' -i /etc/pacman.conf
reflector --latest 15 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
#Настройк Grub загрузчика системы
grub-install --target=i386-pc --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
#Отключение заплаток intel
sed 's/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet rootfstype=btrfs mitigations=off nowatchdog"/g' -i /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
# проги доп
# pacman -S kitty vim stacer neofetch btop ark p7zip unrar qbittorent guvcview 
#Добавление сервисов в автоpагрузку
systemctl enable NetworkManager sshd gdm 
systemctl mask NetworkManager-wait-online.service
echo "Enter reboot now"
rm /end.sh
exit
