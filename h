sudo pacman -S base-devel gdb ninja gcc cmake libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite xorg-xinput libxrender pixman wayland-protocols cairo pango seatd libxkbcommon xcb-util-wm xorg-xwayland cmake wlroots mesa git meson polkit 
git clone --recursive https://github.com/hyprwm/Hyprland
cd Hyprland  
git submodule init  
git submodule update  
sudo make install
cp Hyprland/example/hyprland.conf ~/.config/hypr/
git clone https://github.com/hyprwm/hyprpaper  
cd hyprpaper  
make all  
sudo cp ~/hyprpaper/build/hyprpaper /usr/bin 
pacman -S --needed git base-devel  
git clone https://aur.archlinux.org/yay.git  
cd yay  
makepkg -si  
git clone https://github.com/Alexays/Waybar/  
cd Waybar  
sudo pacman -S fmt spdlog gtkmm3 libdbusmenu-gtk3 upower libmpdclient sndio gtk-layer-shell scdoc  
clang awesome-terminal-fonts jq  

yay catch2-git

sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch   workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp  

meson --prefix=/usr --buildtype=plain --auto-features=enabled --wrap-mode=nodownload build  
meson configure -Dexperimental=true build  
sudo ninja -C build install  
sudo pacman -S sddm
gsettings set org.gnome.desktop.interface icon-theme breeze-icons-dark  
gsettings set org.gnome.desktop.interface gtk-theme Fantome
gsettings set org.gnome.desktop.interface cursor-theme capitaine-cursors
sudo pacman -S firefox imv mpv thunar tumbler wofi mousepad
sudo pacman -S htop links cmus neofetch ranger grim unzip kitty  
git clone https://git.suckless.org/st  
cd st  
edit config.def.h  
sudo make clean install

