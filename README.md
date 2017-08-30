# nmk[![Bash4.2-shield]](http://tldp.org/LDP/abs/html/bashver4.html#AEN21220) [![License-shield]](https://raw.githubusercontent.com/v1s1t0r1sh3r3/airgeddon/master/LICENSE.md)   
Tool kit for generating WPS default PIN for Livebox 2.1 and Lievbox Next from Orange (ISP Spain)  
[![livebox1]]  

# Description
**N**aranja **M**ekani**K** (**nmk**) is a tool kit that porposes different way to genrate the default PIN from: 
 - Arcadyan ARV7519RW22 
 - Arcadyan ARV7520CW22  
 - Arcadyan VRV9510KWAC23  
 The two frist Access Points are also known as **Livebox 2.1** and the thrid one as **Livebox Next**
 Once it such Acess Point is detected the script generates it default PIN and shows it in the shell
 
 # About the WPS breach
The PIN algorithm was investigated and deduced by **wifi-libre** members: [Todo sobre al algoritmo WPS Livebox Arcadyan (Orange-XXXX)](https://www.wifi-libre.com/topic-869-todo-sobre-al-algoritmo-wps-livebox-arcadyan-orange-xxxx.html#p7018)  
It is quite similar to the one discovered by **Stefan Viehböck** on Arcadyan easy-box: [(Vodafone EasyBox Default WPS PIN Algorithm Weakness](http://seclists.org/fulldisclosure/2013/Aug/51)  
THe livebox is quite popular in Spain and we are speaking about more than a milion devices affected.  

# Dependencies

**nmk.sh** requires **wash 1.6.1** (or a superior version) and its depemdemcies.  
This are the general steps in a debian based system to install **reaver 1.6.1** (it includes **wash**)  
 - Install the dependecies    
~~~
sudo apt install libpcap-dev
~~~
 - Install reaver
~~~
git clone https://github.com/t6x/reaver-wps-fork-t6x.git
cd reaver-wps-fork-t6x/src/
./configure
sudo make install
~~~  
Visit [reaver t6x repository](https://github.com/t6x/reaver-wps-fork-t6x) for more information about wash and reaver.  


# How to use nmk.sh?
 - Clone this repository  
 ~~~
 git clone https://github.com/kcdtv/nmk.git
 ~~~
 - Execute the script wth administrator privileges
 ~~~
 cd nmk; sudo bash nmk.sh
 ~~~  
 
 - If several interfaces are avalaible user is prompted to choose  
[![livebox3]]  
 - Once an interface is selected the scan begins and when a vulnerable target is detected it is reported with it PIN genrated  
 [![livebox4]]  
 - Just press CTRL + C to stop the script.  
 Interface is left in monitor mode in order to perform a reaver attack with the deafult PIN.  
 In good conditions WPA key is recovered inmediatly.  
   
   
# How to use orangen.py
```
python orangen.py < 4 last digits mac WAN > < 4 last digits serial > 
```
tip: substract 2 from bSSID to get the WAN MAC  
  
  
# How to use orangen.sh  
Locate your terminal in your "nmk" folder and invocate bash to execute the script  
```
bash orangen.sh
```  
warning: Do **not** moove **orangen.py** from your **nmk** folder; it has to be in your nmk folder when you execute the script.  



# Credits
Full disclosure "Arcadyan livebox PIN generator" by **wifi-libre**, scripts by **kcdtv**





[livebox1]: https://www.wifi-libre.com/img/members/3/livebox_default_PIN_4.jpg
[lievbox2]: http://pix.toile-libre.org/upload/original/1503195806.png
[livebox3]: http://pix.toile-libre.org/upload/original/1503190103.png
[livebox4]: http://pix.toile-libre.org/upload/original/1503191121.png
[lievbox5]: http://pix.toile-libre.org/upload/original/1503197042.png
[Bash4.2-shield]: https://img.shields.io/badge/bash-4.2%2B-blue.svg?style=flat-square&colorA=273133&colorB=00db00 "Bash 4.2 or later"
[License-shield]: https://img.shields.io/badge/license-GPL%20v3%2B-blue.svg?style=flat-square&colorA=273133&colorB=bd0000 "GPL v3+"  
