ARCHS = arm64 armv7
TARGET = iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Nocturne_UIKit
Nocturne_UIKit_FILES = NocturneGlobal.xm NocturnePerApplication.xm UIImage+invertColors.m
Nocturne_UIKit_LDFLAGS += -Wl,-segalign,4000
Nocturne_UIKit_FRAMEWORKS = UIKit CoreImage

include $(THEOS)/makefiles/tweak.mk
