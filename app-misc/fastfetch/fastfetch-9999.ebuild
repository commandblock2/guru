# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Fast system information tool"
HOMEPAGE="https://github.com/LinusDierheimer/fastfetch"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/LinusDierheimer/fastfetch.git"
else
	SRC_URI="https://github.com/LinusDierheimer/fastfetch/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
IUSE="X chafa dbus gnome imagemagick opencl opengl osmesa pci sqlite vulkan wayland xcb xfce xrandr"

# note - qa-vdb will always report errors because fastfetch loads the libs dynamically
RDEPEND="
	sys-libs/zlib
	X? ( x11-libs/libX11 )
	chafa? ( media-gfx/chafa )
	dbus? ( sys-apps/dbus )
	gnome? (
		dev-libs/glib
		gnome-base/dconf
	)
	imagemagick? ( media-gfx/imagemagick:= )
	opencl? ( virtual/opencl )
	opengl? ( media-libs/libglvnd[X] )
	osmesa? ( media-libs/mesa[osmesa] )
	pci? ( sys-apps/pciutils )
	sqlite? ( dev-db/sqlite:3 )
	vulkan? ( media-libs/vulkan-loader )
	wayland? ( dev-libs/wayland )
	xcb? ( x11-libs/libxcb )
	xfce? ( xfce-base/xfconf )
	xrandr? ( x11-libs/libXrandr )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

REQUIRED_USE="
	xrandr? ( X )
	chafa? ( imagemagick )
"

src_configure() {
	local fastfetch_enable_imagemagick7=no
	local fastfetch_enable_imagemagick6=no
	if use imagemagick; then
		fastfetch_enable_imagemagick7=$(has_version '>=media-gfx/imagemagick-7.0.0' && echo yes || echo no)
		fastfetch_enable_imagemagick6=$(has_version '<media-gfx/imagemagick-7.0.0' && echo yes || echo no)
	fi

	local mycmakeargs=(
		-DENABLE_RPM=no
		-DENABLE_LIBPCI=$(usex pci)
		-DENABLE_VULKAN=$(usex vulkan)
		-DENABLE_WAYLAND=$(usex wayland)
		-DENABLE_XCB_RANDR=$(usex xcb)
		-DENABLE_XCB=$(usex xcb)
		-DENABLE_XRANDR=$(usex xrandr)
		-DENABLE_X11=$(usex X)
		-DENABLE_GIO=$(usex gnome)
		-DENABLE_DCONF=$(usex gnome)
		-DENABLE_XFCONF=$(usex xfce)
		-DENABLE_IMAGEMAGICK7=${fastfetch_enable_imagemagick7}
		-DENABLE_IMAGEMAGICK6=${fastfetch_enable_imagemagick6}
		-DENABLE_ZLIB=yes
		-DENABLE_CHAFA=$(usex chafa)
		-DENABLE_SQLITE3=$(usex sqlite)
		-DENABLE_EGL=$(usex opengl)
		-DENABLE_GLX=$(usex opengl)
		-DENABLE_OSMESA=$(usex osmesa)
		-DENABLE_OPENCL=$(usex opencl)
		-DENABLE_DBUS=$(usex dbus)
		-DENABLE_LIBCJSON=no
	)

	cmake_src_configure
}
