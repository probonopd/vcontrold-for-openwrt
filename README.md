vcontrold-for-openwrt [![Build Status](https://travis-ci.org/probonopd/vcontrold-for-openwrt.svg)](https://travis-ci.org/probonopd/vcontrold-for-openwrt)
=====================
![Vitotronic 200 KW2](https://cloud.githubusercontent.com/assets/2480569/5601297/4ab09c20-92f7-11e4-9fd3-328e15ff4303.jpg) ![D-Link DIR 505](https://cloud.githubusercontent.com/assets/2480569/5601325/4f1c2a26-92f8-11e4-846a-ef47d5c96ae3.jpeg)

Control Viessmann heating systems such as the Vitotronic 200 KW 2 from OpenWrt. I have successfully tested this on a D-Link DIR 505 running OpenWrt Barrier Breaker 14.07, but other systems with at least 8 MB flash ROM such as the TP-Link TL-WR710N should also be suitable.

A daemon reading data coming from the control unit of a Vito heating system using an Optolink adapter connected to a serial port.

See http://openv.wikispaces.com/vcontrold for more information.

Downloading
--
Precompiled binaries for common architectures can be found on https://github.com/probonopd/vcontrold-for-openwrt/releases - check the ```.travis.yml``` file to see how this is compiled on http://travis-ci.org automatically. Please file an issue if you need addional architectures and/or OpenWrt versions.

Building
--
To build, pull this repository into the ```package/``` subdirectory in the OpenWrt SDK with ```git clone https://github.com/probonopd/vcontrold-for-openwrt.git```, then run ```./scripts/feeds update ; ./scripts/feeds install -d m libxml2``` and finally ```make V=s```. 

Using
--

First, you need to constuct a device that connects your OpenWrt system to your Viessmann heating system. You can build one from very inexpensive parts (under 10 EUR) yourself following the instructions [here](http://openv.wikispaces.com/Bauanleitung+3.3V+TTL).

Next, you need to install the USB-to-serial adaptor driver on your OpenWrt system. For Prolific-based adapters like the PL2303HX used in the instructions, do
```
opkg update
opkg install kmod-usb-serial-pl2303
```

Now, edit ```/etc/vcontrold/vcontrold.xml``` so that it uses the correct serial port. If you have only one USB-to-serial adaptor connected to your OpenWrt system, this is usually ```/dev/ttyUSB0```:
```
        <serial>
                <tty>/dev/ttyUSB0</tty>
        </serial>
```

Next, make sure that the correct device is selected, like ```<device ID="2098"/>``` of you have a Vitotronic 200 KW 2.

__Imporant security note:__ If you do not want your heating system to be accessible from the entire LAN, make sure that you remove the line ```<allow ip='192.168.1.0/24'/>```.

Now, do ```/etc/init.d/vcontrold disable``` and edit the ```/etc/init.d/vcontrold``` init script since the stock one is not working on OpenWrt (TODO: fix it):
```
#!/bin/sh /etc/rc.common

START=90
DAEMON=/usr/sbin/vcontrold

start() {
        service_start $DAEMON
}

stop() {
        service_stop $DAEMON
}
```

Afterwards restart vcontrold with
```
/etc/init.d/vcontrold enable
/etc/init.d/vcontrold restart
```

Finally, you should be able to issue commands and get back responses from your Viessmann heating system:
```
root@OpenWrt:~# vclient -h 127.0.0.1:3002 -c getTempA
getTempA:
2.600000 Grad Celsius
```
