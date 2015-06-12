include theos/makefiles/common.mk

BUNDLE_NAME = ShareMemos
ShareMemos_FILES = ShareMemos.mm
ShareMemos_INSTALL_PATH = /Library/PreferenceBundles
ShareMemos_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore CoreImage Accelerate AVFoundation AudioToolbox MobileCoreServices Social Accounts MediaPlayer
ShareMemos_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ShareMemos.plist$(ECHO_END)
