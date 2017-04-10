ARCHS = arm64 armv7
TARGET = iphone:clang:latest:8.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Nocturne
Nocturne_FILES = GlobalHook.xm
Nocturne_LDFLAGS += -Wl,-segalign,4000
Nocturne_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Preferences"
