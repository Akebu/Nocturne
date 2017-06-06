ARCHS = arm64 armv7
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 7.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Nocturne_Phone
Nocturne_Phone_FILES = Tweak.xm
Nocturne_Phone_LDFLAGS += -Wl,-segalign,4000
Nocturne_Phone_FRAMEWORKS = UIKit

include $(THEOS)/makefiles/tweak.mk


