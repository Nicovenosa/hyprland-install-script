#!/bin/bash

# Actualizar el sistema
sudo pacman -Syu

# Instalar controladores NVIDIA
sudo pacman -S nvidia nvidia-utils

# Configurar el parámetro del kernel para usar KMS con NVIDIA
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& nvidia-drm.modeset=1/' /etc/default/grub

# Actualizar GRUB
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Instalar paquetes necesarios para Wayland y Hyprland
sudo pacman -S wayland wayland-protocols xorg-xwayland

# Instalar Hyprland desde AUR usando yay (si no tienes yay instalado, instálalo primero)
if ! command -v yay &> /dev/null
then
    echo "yay no está instalado. Instalando yay..."
    sudo pacman -S --needed base-devel git
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm -rf yay
fi

yay -S hyprland-git

# Crear directorio de configuración para Hyprland si no existe
mkdir -p ~/.config/hypr/

# Crear un archivo de configuración básico para Hyprland con recomendaciones para NVIDIA
cat <<EOL > ~/.config/hypr/hyprland.conf
# Configuración básica para Hyprland
general {
    # Selecciona la pantalla predeterminada
    monitor = 0
    # Habilitar variable de entorno recomendada para NVIDIA
    export WLR_NO_HARDWARE_CURSORS=1
}

input {
    # Configuración de entrada
    kb_layout = us
    kb_variant = 
}
EOL

echo "Instalación y configuración completa. Reinicia el sistema para aplicar los cambios."
