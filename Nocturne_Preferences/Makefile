ARCHS = arm64 armv7
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 7.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Nocturne_Preferences
Nocturne_Preferences_FILES = AirPortSettings.xm WirelessModemSettings.xm
Nocturne_Preferences_LDFLAGS += -Wl,-segalign,4000
Nocturne_Preferences_FRAMEWORKS = UIKit CoreImage

include $(THEOS)/makefiles/tweak.mk


