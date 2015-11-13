ARCHS = armv7 arm64
THEOS_BUILD_DIR = Packages
THEOS_DEVICE_IP = 192.168.1.82
include theos/makefiles/common.mk

TWEAK_NAME = Indago
Indago_FILES = Indago.xm IndagoWindow.m IndagoBrowserViewController.m IndagoSearchBarViewController.m IndagoObfuscatedString.m
Indago_LIBRARIES = substrate activator
Indago_FRAMEWORKS = Foundation UIKit CoreGraphics QuartzCore WebKit
Indago_LDFLAGS += -Wl,-segalign,4000
Indago_CODESIGN_FLAGS = -Sentitlements.xml

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += indagoprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
