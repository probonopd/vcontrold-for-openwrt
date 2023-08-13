#
# NEED to run first:
# ./scripts/feeds update
# ./scripts/feeds install -d m libxml2
#

include $(TOPDIR)/rules.mk

PKG_NAME:=vcontrold
PKG_VERSION:=0.98.12
PKG_REV:=v$(PKG_VERSION)
PKG_RELEASE:=1

PKG_SOURCE_URL:=https://github.com/openv/$(PKG_NAME).git
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_PROTO:=git

PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/version.mk
include $(INCLUDE_DIR)/cmake.mk

BUILD_DEPENDS:=+libxml2
CMAKE_OPTIONS += -DMANPAGES=OFF
CMAKE_BINARY_SUBDIR:=$(PKG_NAME)

define Package/$(PKG_NAME)
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+libxml2
  TITLE:=Daemon for Vito communication
  URL:=https://github.com/openv/openv/wiki
endef

define Package/$(PKG_NAME)/description
A daemon reading data coming from the control unit of a Vito heating
system using an Optolink adapter connected to a serial port.
endef

define Build/Prepare
	$(call Build/Prepare/Default)
	$(CP) ./files/* $(PKG_BUILD_DIR)/
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_NAME)/vclient $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_NAME)/$(PKG_NAME) $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_NAME).initscript $(1)/etc/init.d/vcontrold

	$(INSTALL_DIR) $(1)/etc/vcontrold
	$(INSTALL_DIR) $(1)/etc/vcontrold/300
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/xml/300/*.xml $(1)/etc/$(PKG_NAME)/300/
	$(INSTALL_DIR) $(1)/etc/vcontrold/kw
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/xml/kw/*.xml $(1)/etc/$(PKG_NAME)/kw/
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/$(PKG_NAME).uci $(1)/etc/config/$(PKG_NAME)
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/admin/
	$(CP) $(PKG_BUILD_DIR)/vclient.lua $(1)/usr/lib/lua/luci/controller/admin/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/admin_heating/
	$(CP) $(PKG_BUILD_DIR)/vclient.htm $(1)/usr/lib/lua/luci/view/admin_heating/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
