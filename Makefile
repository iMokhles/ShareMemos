GO_EASY_ON_ME = 1
export SDKVERSION=8.1
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 6.0
ADDITIONAL_CFLAGS = -fobjc-arc

include theos/makefiles/common.mk

TWEAK_NAME = ShareMemos
ShareMemos_FILES = Tweak.xm $(wildcard *.m)
ShareMemos_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore CoreImage Accelerate AVFoundation AudioToolbox MobileCoreServices Social Accounts AssetsLibrary AdSupport MediaPlayer SystemConfiguration MessageUI
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 VoiceMemos"
SUBPROJECTS += ShareMemos
include $(THEOS_MAKE_PATH)/aggregate.mk