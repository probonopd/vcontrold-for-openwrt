#
# NEED to run first:
# ./scripts/feeds update
# ./scripts/feeds install -d m libxml2
#

include $(TOPDIR)/rules.mk

PKG_NAME:=vcontrold

PKG_REV:=106
PKG_VERSION:=$(PKG_REV)
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://svn.code.sf.net/p/vcontrold/code/trunk/
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_PROTO:=svn

PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

MAKE_PATH:=vcontrold
CONFIGURE_PATH:=vcontrold

BUILD_DEPENDS:=+libxml2

define Package/vcontrold
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+libxml2
  TITLE:=Daemon for Vito communication
  URL:=http://openv.wikispaces.com/vcontrold
endef

define Package/vcontrold/description
A daemon reading data coming from the control unit of a Vito heating
system using an Optolink adapter connected to a serial port.
endef

define Build/Prepare
    $(call Build/Prepare/Default)
#    $(CP) ./files/* $(PKG_BUILD_DIR)/
endef

define Build/Configure
	(cd $(PKG_BUILD_DIR)/vcontrold && aclocal && autoconf && touch NEWS README AUTHORS ChangeLog && automake --add-missing)
	$(call Build/Configure/Default, \
		--with-xml2-include-dir=$(STAGING_DIR)/usr/include/libxml2 \
	)
endef

define Package/vcontrold/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/vcontrold/vclient $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/vcontrold/vcontrold $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/vcontrold/vcontrold.initd.sh $(1)/etc/init.d/vcontrold

	$(INSTALL_DIR) $(1)/etc/vcontrold
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/vcontrold/vcontrold.xml $(1)/etc/vcontrold/vcontrold_dev-id-2098.xml
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/xml-32/xml/*.{xml,ini} $(1)/etc/vcontrold/
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/admin/
	$(CP) ./files/vclient.lua $(1)/usr/lib/lua/luci/controller/admin/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/admin_heating/
	$(CP) $./files/vclient.htm $(1)/usr/lib/lua/luci/view/admin_heating/
endef

$(eval $(call BuildPackage,vcontrold))
