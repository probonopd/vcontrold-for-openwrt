vcontrold-for-openwrt [![Build Status](https://travis-ci.org/probonopd/vcontrold-for-openwrt.svg)](https://travis-ci.org/probonopd/vcontrold-for-openwrt)
=====================
A daemon reading data coming from the control unit of a Vito heating system using an Optolink adapter connected to a serial port.

See http://openv.wikispaces.com/vcontrold for more information.

Downloading
--
Precompiled binaries for common architectures can be found on https://github.com/probonopd/vcontrold-for-openwrt/releases - check the ```.travis.yml``` file to see how this is compiled on http://travis-ci.org automatically. Please file an issue if you need addional architectures and/or OpenWrt versions.

Building
--
To build, pull this repository into the ```package/``` subdirectory in the OpenWrt SDK with ```git clone https://github.com/probonopd/vcontrold-for-openwrt.git```, then run ```./scripts/feeds update ; ./scripts/feeds install -d m libxml2``` and finally ```make V=s```. 
