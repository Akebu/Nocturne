include $(THEOS)/makefiles/common.mk

SUBPROJECTS += Nocturne_UIKit
SUBPROJECTS += Nocturne_Preferences
SUBPROJECTS += Nocturne_Phone
SUBPROJECTS += Nocturne_ContactsUI
SUBPROJECTS += Nocturne_PhotosUI
SUBPROJECTS += Nocturne_StoreKitUI

include $(THEOS_MAKE_PATH)/aggregate.mk

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	@install.exec "killall -9 Phone"
