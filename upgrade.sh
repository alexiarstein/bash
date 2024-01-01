#!/bin/bash

# Debian Package Updater
# ----------------------
# Author: Alexia Steinberg <alexiarstein@aol.com>
# Purpose: List and learn about different packages which require updating
# and select them independently for updating.
# This early release might have a ton of bugs, feel free to create issues or suggest fixes, or fix it yourself
# and send a pull request.

version="v1.0.0"
lgn=$(logname)
fullname=$(grep $lgn /etc/passwd | awk -F ':' '{print $5}' | sed 's/,//g')
opf="/tmp/upgrade"

if [ ! -f ~/.deb-package-updater.conf ]; then
echo -e "\nDebian Package Updater Selector $version\n"
echo "[EN]: Looks like this is your first time running this script"
echo "      Would you rather keep this settings or switch to Spanish?"
echo "[ES]: Parece que es la primera vez que corrés este script"
echo "      ¿Querés conservar esta configuración o pasarte a inglés?"
echo ""
echo "SELECT: 1: Use English | 2: Usar Español"
read x
case $x in
1)
echo 'declare -A tr=(
["title"]="Package Update Selection"
["backtitle"]="Hello ${fullname}!                                              (Debian Package Upgrader $version by Alexia Steinberg <alexiarstein@aol.com>)"
["select-package"]="Select Packages to Update"
["package-successful"]="Package(s) Updated Successfully!"
["package-failed"]="No Packages were updated."
["updatecomplete"]="Update Complete"
["updatecanceled"]="Update Canceled"
["systemupdated"]="Your system is up to date. Yay!"

)' > ~/.deb-package-updater.conf
echo "Language set to ENGLISH. To clear this selection remove the file .deb-package-updater.conf in your homedir"
echo "run this tool again for changes to take effect."
exit 1
;;
2)
echo '
declare -A tr=(
["title"]="Seleccionar Paquetes a Actualizar"    
["backtitle"]="Hola ${fullname}!                                              (Debian Package Upgrader $version Por Alexia Steinberg <alexiarstein@aol.com>"
["select-package"]="Selecione que paquetes desea actualizar:"
["package-successful"]="¡Paquetes actualizados con éxito!"
["package-failed"]="No se actualizaron paquetes."
["updatecomplete"]="Actualizacion Completa"
["updatecanceled"]="Actualizacion Cancelada"
["systemupdated"]="No hay paquetes para actualizar. Tu sistema está al día"
)' > ~/.deb-package-updater.conf
echo "Lenguaje configurado: ESPAÑOL. Para remover esta configuración, eliminar el archivo .deb-package-updater.conf en tu homedir"
echo "correr nuevamente esta herramienta para que tome los cambios."
exit 1
;;
*)
echo "error"
exit 1
;;
esac
else
source ~/.deb-package-updater.conf
fi
# por ahora comentado. No me termina de convencer.
#if grep -q "Listing..." "$opf"; then
#echo "${tr[systemupdated]}"
#exit 1
#else
#sudo apt list --upgradable | grep -v "Listing..." | awk -F '/' '{print $1}' > /tmp/upgrade
#fi

# El segundo intento evalua si el output para paquetes es igual a 0 bytes. Si es igual a 0 no hay updates
# si es mayor que 0 entonces algo logueo jej (habria updates)
# Primero genero la lista de paquetes, que puede tener o no tener paquetes.
sudo apt list --upgradable | grep -v "Listing..." | awk -F '/' '{print $1}' > /tmp/upgrade

# Y ahora si. Si dicha lista pesa 0 bytes, entonces no hay updates, modo contrario continua el resto del script.
# Si se les ocurre una manera mas eficiente de razonarlo, por favor envien pull request.
if [ ! -s "$opf" ]; then
echo "${tr[systemupdated]}"
exit 0
fi

declare -A tr=(
["title"]="Seleccionar Paquetes a Actualizar"    
["backtitle"]="Hola ${fullname}!                                              (Debian Package Upgrader $version Por Alexia Steinberg <alexiarstein@aol.com>"
["select-package"]="Selecione que paquetes desea actualizar:"
["package-successful"]="¡Paquetes actualizados con éxito!"
["package-failed"]="No se actualizaron paquetes."
["updatecomplete"]="Actualizacion Completa"
["updatecanceled"]="Actualizacion Cancelada"


# Create an array to store options
options=()

# Read each line from the file and add it to the array
while IFS= read -r i; do
    options+=("$i" "" off)
done < "$opf"


# Use whiptail to create a menu
selected_options=$(whiptail --title "${tr[title]}" --checklist \
"${tr[select-package]}" 20 60 10 "${options[@]}" --backtitle "${tr[backtitle]}" 3>&1 1>&2 2>&3)

# Check if the user pressed Cancel or Esc
if [ $? -eq 0 ]; then
    # User pressed OK, proceed with the update
    for selected_option in $selected_options; do
        # Remove double quotes from the selected option
        package_name=$(echo "$selected_option" | tr -d '"')
        sudo apt install "$package_name" -y --only-upgrade
    done
    whiptail --title "${tr[updatecomplete]}" --msgbox "${tr[package-successful]}" 8 50
else
    # User pressed Cancel or Esc
    whiptail --title "${tr[updatecanceled]}" --msgbox "${tr[package-failed]}" 8 50
fi
