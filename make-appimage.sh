#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q k3b | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/128x128/apps/k3b.png
export DESKTOP=/usr/share/applications/org.kde.k3b.desktop

# Deploy dependencies
quick-sharun \
	/usr/bin/k3b                     \
	/usr/share/k3b                   \
	/usr/lib/qt6/plugins/k3b_plugins \
	/usr/lib/qt6/plugins/kf6         \
	/usr/bin/cdparanoia              \
	/usr/bin/dvd*                    \
	/usr/bin/growisofs

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
