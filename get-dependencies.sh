#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm cdparanoia dvd+rw-tools qt6ct kvantum lxqt-qtplugin

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano x265-mini kiconthemes-mini

# Comment this out if you need an AUR package
export PRE_BUILD_CMDS="
	sed -i -e '/webengine/d' ./PKGBUILD
	sed -i -e 's|LIBEXECDIR=lib|LIBEXECDIR=lib -DHAVE_QTWEBENGINEWIDGETS=OFF|' ./PKGBUILD
"
make-aur-package --archlinux-pkg k3b

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
