ARCHS = arm64 armv7
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 7.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Nocturne_UIKit
Nocturne_UIKit_FILES = NocturnePerApplications.xm NocturneGlobal.xm UIImage+extention.m
Nocturne_UIKit_LDFLAGS += -Wl,-segalign,4000

Nocturne_UIKit_FRAMEWORKS = UIKit CoreImage CoreGraphics

include $(THEOS)/makefiles/tweak.mk
