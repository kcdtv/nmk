#! /bin/bash
# orangen.sh: Default pin generator for livebox 2.1 and livebox next
# Algorithm and vulnerability by wifi-libre. For more details check https://www.wifi-libre.com/topic-869-todo-sobre-al-algoritmo-wps-livebox-arcadyan-orange-xxxx.html
# This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
# Contact script author: kcdtv@wifi-libre.com
# Copyleft (C) 2017 kcdtv @ www.wifi-libre.com

# Global variables:
grey="\033[0;37m"
orange="\033[38;5;202m"

ls orangen.sh  || { echo -e "ERROR: Para ejecutar el script debes situar tu terminal en la carpeta nmk y el script orangen.py debe estar presente en la carpeta nmk"; exit 1; }
until  [[ "$(echo $bssid | tr A-F a-f | egrep -o '^[0-9a-f]{6}' | wc -c)" == 7 ]];
  do
   read -n 8 -ep  "Entra la segunda mitad del bssid: " mac
   bssid=$( echo $mac | tr -d ':' )
done
ssid=$( echo $bssid | cut -c 3-)
wan=$(printf "%X\n" $(( 0x$(echo $ssid) - 2 )))
until  [[ "$(echo $serial | egrep -o '^[0-9]{4}' | wc -c)" == 5 ]];
  do
   read -n 4 -ep  "Entra los 4 ultimos digitos del numero de sere: " seri
   serial=$( echo $seri | rev | cut -c -4 | rev )
done
echo -e "PIN por defecto > $orange"
python livebox.py $wan $serial
echo -e "$grey
Copyleft (C) 2017 kcdtv @ www.wifi-libre.com"
