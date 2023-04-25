TARGET := iphone:clang:latest
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = InternalTest

InternalTest_FILES = Tweak.x
InternalTest_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
