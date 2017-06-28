# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils autotools eutils versionator

REVISION="6404"
DESCRIPTION="A fork of the famous open racing car simulator TORCS"
HOMEPAGE="http://speed-dreams.sourceforge.net/"
SRC_URI="mirror://sourceforge/speed-dreams/${PN}-src-base-${PV}-r$REVISION.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
#"~amd64 ~x86"
IUSE="xrandr"

RDEPEND="virtual/opengl
	virtual/glu
	media-libs/freealut
	media-libs/freeglut
	>=media-libs/libpng-1.2.40:0
	media-libs/openal
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXxf86vm
	media-libs/libogg
	media-libs/libsdl2
	media-libs/freetype
	net-misc/curl
	virtual/jpeg
	xrandr? ( x11-libs/libXrandr )"
DEPEND="${RDEPEND}
    dev-games/openscenegraph
	>=media-libs/plib-1.8.3
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXt
	x11-libs/libXmu
	x11-libs/libXrender
	x11-proto/xproto
	xrandr? ( x11-proto/randrproto )"

S=${WORKDIR}

PATCHES=(
	#"${FILESDIR}"/${PN}-1.4.0-asneeded.patch
	#"${FILESDIR}"/${PN}-1.4.0-automake.patch
	#"${FILESDIR}"/${PN}-1.4.0-libpng15.patch
	#"${FILESDIR}"/${PN}-1.4.0-math-hack.patch
)

src_prepare() {
	# https://sourceforge.net/apps/trac/speed-dreams/ticket/111
	MAKEOPTS="${MAKEOPTS} -j1"

    cmake-utils_src_prepare
}

src_configure() {
#	addpredict $(echo /dev/snd/controlC? | sed 's/ /:/g')
#	[[ -e /dev/dsp ]] && addpredict /dev/dsp
#	econf \
#		--prefix=/usr \
#		--bindir=/usr/bin \
#		$(use_enable xrandr)
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPEE=Release
		-DRELEASE_COMPILE_FLAGS=""
		-DCMAKE_SKIP_RPATH=ON
		-SD_LOCALDIR:STRING=$HOME/.speed-dreams
	)

	cmake-utils_src_configure
}

src_install() {
	emake DESTDIR="${D}" install datainstall

	dodoc CHANGES.txt README.txt

	newicon icon.svg ${PN}.svg
	make_desktop_entry ${PN} "Speed Dreams"
}
