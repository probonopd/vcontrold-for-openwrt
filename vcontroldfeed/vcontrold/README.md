vcontrold-for-openwrt [![Build Status](https://travis-ci.org/probonopd/vcontrold-for-openwrt.svg)](https://travis-ci.org/probonopd/vcontrold-for-openwrt)
=====================
![Vitotronic 200 KW2](https://cloud.githubusercontent.com/assets/2480569/5601297/4ab09c20-92f7-11e4-9fd3-328e15ff4303.jpg) ![D-Link DIR 505](https://cloud.githubusercontent.com/assets/2480569/5601325/4f1c2a26-92f8-11e4-846a-ef47d5c96ae3.jpeg)

Control Viessmann heating systems such as the Vitotronic 200 KW2 from OpenWrt. I have successfully tested this on a D-Link DIR 505 running OpenWrt Barrier Breaker 14.07, but other systems with at least 8 MB flash ROM such as the TP-Link TL-WR710N should also be suitable.

See http://openv.wikispaces.com/vcontrold for more information.

![deutsch](https://cloud.githubusercontent.com/assets/2480569/5602556/6f564aee-9355-11e4-8d53-c38a2ef587c2.gif)
 Note for German readers: [Anleitung auf Deutsch](http://openv.wikispaces.com/vcontrold+auf+OpenWrt).

Downloading
--
Precompiled binaries for common architectures can be found on https://github.com/probonopd/vcontrold-for-openwrt/releases - check the ```.travis.yml``` file to see how this is compiled on http://travis-ci.org automatically. Please file an issue if you need addional architectures and/or OpenWrt versions.

Building
--
To build, pull this repository into the ```package/``` subdirectory in the OpenWrt SDK with ```git clone https://github.com/probonopd/vcontrold-for-openwrt.git```, then run ```./scripts/feeds update ; ./scripts/feeds install -d m libxml2``` and finally ```make V=s```. 

Using
--

First, you need to constuct a device that connects your OpenWrt system to your Viessmann heating system called an Optolink adapter. You can build one from very inexpensive parts (under 10 EUR) yourself following the instructions [here](http://openv.wikispaces.com/Bauanleitung+3.3V+TTL).

* 1x SFH487-2 infrared LED
* 1x SFH309FA infrared phototransistor
* 1x 100 Ohm or 330 Ohm (for operation at 5V) 1/4 W resistor
* 3x 10k Ohm (for operation at 3.3V) or 15k Ohm (for operation at 5V) 1/4 W resistors
* 1x 2N3906 PNP transistor
* 1x BC547A NPN transistor
* 4x jumpers (computer)
* 1x 170 tie-point circuit test breadboard (eBay/China under 2 USD shipped)
* 1x PL2303HX USB to RS232 TTL converter (most operate at 5V; eBay/China under 2 USD shipped)
* Wires

![opto_usb](https://cloud.githubusercontent.com/assets/2480569/5601516/441d5e36-9304-11e4-82c3-bec1304da5fc.png)

Note that I used a 330 Ohm resistor instead of the 100 Ohm resistor in the picture; it is working for me. Also note that if you use 5V instead of 3.3V (some PL2303HX adaptors only have a 5V pin), then you should use three 15k Ohm resistors instead of the three 10k Ohm resistors in the picture (I have not verified this yet).

The whole electronics can be installed inside the original red cover of the Vitotronic 200 KW2, so that it becomes completely invisible:

![3](https://cloud.githubusercontent.com/assets/2480569/5628244/d56e61c6-95a4-11e4-920e-d2d1d3ea9ee5.jpg)

Next, you need to install the USB-to-serial adaptor driver on your OpenWrt system. For Prolific-based adaptors like the PL2303HX used in the instructions, do
```
opkg update
opkg install kmod-usb-serial-pl2303
```

ATTENTION!  
vcontrold version >= 0.98.12  
!!!
--

Configuration split 
```
/etc/vcontrold/kw/
```
and
```
/etc/vcontrold/300/
```
set protocol to 'kw' or '300'  
default: 'kw'
```
uci set vcontrold.main.protocol='300'
uci commit
```
you can also create a custom configuration
```
cd /etc/vcontrold
cp -r kw/ custom
uci set vcontrold.main.protocol='custom'
uci commit
```
!!!
--


Now, edit ```/etc/vcontrold/[kw|300|custom]/vcontrold.xml``` so that it uses the correct serial port. If you have only one USB-to-serial adaptor connected to your OpenWrt system, this is usually ```/dev/ttyUSB0```:
```
        <serial>
                <tty>/dev/ttyUSB0</tty>
        </serial>
```

Next, make sure that the correct device is selected, like ```<device ID="2098"/>``` of you have a Vitotronic 200 KW2.

__Imporant security note:__ If you do not want your heating system to be accessible from the entire LAN, make sure that you remove the line ```<allow ip='192.168.1.0/24'/>```.

Now, enable and start vcontrold with
```
/etc/init.d/vcontrold enable
/etc/init.d/vcontrold start
```
It will be started automatically on each boot.

Finally, you should be able to issue commands and get back responses from your Viessmann heating system:
```
root@OpenWrt:~# vclient -h 127.0.0.1:3002 -c getTempA
getTempA:
2.600000 Grad Celsius
```

GUI
--

There is a work-in-progress graphical user interface for OpenWrt. You can find it in the OpenWrt administration panel under "Heating".

![luci gui](https://cloud.githubusercontent.com/assets/2480569/5602366/785d50ae-9348-11e4-90fd-51525a9a1ad1.png)

Help
--

Please file an issue if you would like to see functionality supported or have a question.
