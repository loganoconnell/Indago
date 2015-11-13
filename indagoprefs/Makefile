ARCHS = armv7 arm64
include theos/makefiles/common.mk

BUNDLE_NAME = IndagoPrefs
IndagoPrefs_FILES = IndagoPrefs.m IndagoShimmeringView.m
IndagoPrefs_INSTALL_PATH = /Library/PreferenceBundles
IndagoPrefs_LIBRARIES = MobileGestalt substrate activator
IndagoPrefs_FRAMEWORKS = Foundation UIKit CoreGraphics QuartzCore MessageUI
IndagoPrefs_PRIVATE_FRAMEWORKS = Preferences Twitter

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/IndagoPrefs.plist$(ECHO_END)
