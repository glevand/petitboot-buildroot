################################################################################
#
# ps3-utils
#
################################################################################

PS3_UTILS_VERSION = c9d3b1279857e546f34233520d679c979b4af8ac
PS3_UTILS_SITE = git://git.kernel.org/pub/scm/linux/kernel/git/geoff/ps3-utils.git
PS3_UTILS_LICENSE = GPLv2
PS3_UTILS_LICENSE_FILES = COPYING

PS3_UTILS_AUTORECONF = YES

PS3_UTILS_CONF_OPTS += \
	PACKAGE_VERSION=g$(PS3_UTILS_VERSION)

$(eval $(autotools-package))
