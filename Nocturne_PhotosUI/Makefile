ARCHS = arm64 armv7
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 7.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Nocturne_PhotosUI
Nocturne_PhotosUI_FILES = Tweak.xm
Nocturne_PhotosUI_LDFLAGS += -Wl,-segalign,4000
Nocturne_PhotosUI_FRAMEWORKS = UIKit

include $(THEOS)/makefiles/tweak.mk


