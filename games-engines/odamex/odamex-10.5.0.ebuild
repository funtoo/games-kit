# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0"
inherit cmake desktop gnome2-utils readme.gentoo-r1 wxwidgets

DESCRIPTION="Online multiplayer, free software engine for Doom and Doom II"
HOMEPAGE="https://odamex.net/"
SRC_URI="https://github.com/odamex/odamex/releases/download/10.5.0/odamex-src-10.5.0.tar.xz -> odamex-src-10.5.0.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="+client hidpi master +odalaunch server upnp X"
REQUIRED_USE="|| ( client master server )"

# protobuf is still bundled. Unfortunately an old version is required for C++98
# compatibility. We could use C++11, but upstream is concerned about using a
# completely different protobuf version on a multiplayer-focused engine.

RDEPEND="
	net-misc/curl
	sys-libs/zlib
	client? (
		media-libs/libpng:0=
		media-libs/libsdl2[joystick,sound,video]
		media-libs/sdl2-mixer[midi,timidity]
		net-misc/curl
		!hidpi? ( x11-libs/fltk:1 )
		X? ( x11-libs/libX11 )
	)
	odalaunch? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )
	server? (
		dev-libs/jsoncpp:=
		upnp? ( net-libs/miniupnpc:= )
	)"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/cmake-3.13
	games-util/deutex"

DOC_CONTENTS="
	This is just the engine, you will need doom resource files in order to play.
	Check: http://odamex.net/wiki/FAQ#What_data_files_are_required.3F
"
PATCHES=(
	"${FILESDIR}"/"${PN}-10.3.0-unbundle-fltk.patch"
)

S="${WORKDIR}/${PN}-src-${PV}"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DUSE_INTERNAL_FLTK=$(usex hidpi)
		-DUSE_INTERNAL_JSONCPP=0
		-DUSE_INTERNAL_LIBS=0
		-DUSE_INTERNAL_MINIUPNP=0
		-DBUILD_CLIENT=$(usex client)
		-DBUILD_LAUNCHER=$(usex odalaunch)
		-DBUILD_MASTER=$(usex master)
		-DBUILD_SERVER=$(usex server)
		-DBUILD_OR_FAIL=1
		-DENABLE_PORTMIDI=NO
		-DUSE_MINIUPNP=$(usex upnp)
	)

	append-cxxflags -std=c++11

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
	readme.gentoo_create_doc

	if use client ; then
		for size in 96 128 256 512; do
			newicon -s ${size} "${S}/media/icon_${PN}_${size}.png" "${PN}.png"
		done
		make_desktop_entry "${PN}" "Odamex"

		if use odalaunch ; then
			for size in 96 128 256 512; do
				newicon -s ${size} "${S}/media/icon_odalaunch_${size}.png" "odalaunch.png"
			done
			make_desktop_entry odalaunch "Odamex Launcher" odalaunch
		fi
	fi
}

pkg_postinst() {
	gnome2_icon_cache_update
	readme.gentoo_print_elog
}

pkg_postrm() {
	gnome2_icon_cache_update
}
# vim: ts=4 noet syn=ebuild