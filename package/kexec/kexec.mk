################################################################################
#
# kexec
#
################################################################################

KEXEC_VERSION = c3f043241a866a7af9117396634dfcb20f0fd9cb
KEXEC_SITE = git://git.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git
KEXEC_LICENSE = GPL-2.0
KEXEC_LICENSE_FILES = COPYING

KEXEC_AUTORECONF = YES

# Makefile expects $STRIP -o to work, so needed for !BR2_STRIP_strip
KEXEC_MAKE_OPTS = STRIP="$(TARGET_CROSS)strip"

ifeq ($(BR2_PACKAGE_KEXEC_ZLIB),y)
KEXEC_CONF_OPTS += --with-zlib
KEXEC_DEPENDENCIES = zlib
else
KEXEC_CONF_OPTS += --without-zlib
endif

ifeq ($(BR2_PACKAGE_XZ),y)
KEXEC_CONF_OPTS += --with-lzma
KEXEC_DEPENDENCIES += xz
else
KEXEC_CONF_OPTS += --without-lzma
endif

define KEXEC_REMOVE_LIB_TOOLS
	rm -rf $(TARGET_DIR)/usr/lib/kexec-tools
endef

KEXEC_POST_INSTALL_TARGET_HOOKS += KEXEC_REMOVE_LIB_TOOLS

$(eval $(autotools-package))
