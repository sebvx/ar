#!/bin/bash
#arch install script
# Создание разделов диска
lsblk
read -p "Disk =  " AddDisk
read -p "kill disk? (y,n) =  " Kill
if [[ $Kill == "y" ]] 
then
  echo -e "wipefs --all /dev/$AddDisk"
else
  echo 'Go go go '
fi
echo -e "n\np\n1\n\n+824M\nn\np\n2\n\n\na\n1\nw\n" | fdisk /dev/$AddDisk
#Форматирование разделов
mkfs.fat -F32 -n BOOT /dev/sda1
mkfs.btrfs -f -L ROOT /dev/sda2
#Монтируем раздел
mount /dev/sda2 /mnt
#Создаём BTRFS тома
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@tmp
#btrfs su cr /mnt/@snapshots
#Отмантируем раздел
umount /dev/sda2
#Монтируем тома в разделы со сжатием и свойствами
mount -o noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,subvol=@ /dev/sda2  /mnt/
mkdir -p /mnt/{boot/EFI,home,tmp,.snapshots}
mount -o noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,subvol=@home /dev/sda2  /mnt/home
#mount -o noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,subvol=@snapshots /dev/sda2  /mnt/.snapshots
mount -o noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,subvol=@tmp /dev/sda2  /mnt/tmp
mount dev/sda1 /mnt/boot/EFI


#Время и ллокаль
timedatectl set-ntp true


#pacman
sed 's/Architecture = auto/Architecture = auto \n ILoveCandy/g' -i /etc/pacman.conf
sed 's/#ParallelDownloads = 5/ParallelDownloads = 10/g' -i /etc/pacman.conf
sed 's/#Color/Color/g' -i /etc/pacman.conf
pacman -Syy --noconfirm
reflector --latest 15 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

#Установка
pacstrap /mnt base base-devel btrfs-progs linux-zen linux-zen-headers linux-zen-docs linux-firmware grub grub-btrfs os-prober efibootmgr dosfstools mtools sudo reflector wget curl git kitty vim  networkmanager openssh xorg virtualbox-guest-modules-arch
 xterm cinnamon gdm

#Генерация fstab
genfstab -U -p /mnt >> /mnt/etc/fstab

#копируем фторую часть скрипта в новую систему
cp /root/ar/end.sh /mnt/
chmod +x /mnt/end.sh
#переходим в новую систему и там запускаем вторую часть /in.sh
arch-chroot /mnt sh -c /end.sh
