# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop xdg flag-o-matic

DESCRIPTION="A modder-friendly OpenGL source port based on the DOOM engine"
HOMEPAGE="https://zdoom.org"
SRC_URI="https://github.com/ZDoom/gzdoom/tarball/71c40432e5e893c629a1c9c76a523a0ab22bd56a -> gzdoom-4.12.2-71c4043.tar.gz"

LICENSE="Apache-2.0 BSD BZIP2 GPL-3 LGPL-2.1+ LGPL-3 MIT"
SLOT="0"
KEYWORDS="*"
IUSE="debug gles2 gtk openmp +swr telemetry vulkan"

DEPEND="
	app-arch/bzip2
	media-libs/libjpeg-turbo:0=
	media-libs/libsdl2[gles2?,opengl,vulkan?]
	media-libs/libvpx:=
	media-libs/libwebp
	media-libs/openal
	media-libs/zmusic
	sys-libs/zlib
	gtk? ( x11-libs/gtk+:3 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/ZDoom-gzdoom-71c4043"


src_prepare() {
	rm -rf docs/licenses || die
	rm -rf libraries/{bzip2,jpeg,zlib} || die

	cmake_src_prepare
}

src_configure() {
	# https://bugs.gentoo.org/858749
	filter-lto
	append-flags -fno-strict-aliasing

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DINSTALL_DOCS_PATH="${EPREFIX}/usr/share/doc/${PF}"
		-DINSTALL_PK3_PATH="${EPREFIX}/usr/share/doom"
		-DINSTALL_SOUNDFONT_PATH="${EPREFIX}/usr/share/doom"
		-DDYN_OPENAL=OFF
		-DNO_GTK="$(usex !gtk)"
		-DNO_OPENAL=OFF
		-DHAVE_VULKAN="$(usex vulkan)"
		-DHAVE_GLES2="$(usex gles2)"
		-DNO_OPENMP="$(usex !openmp)"
		-DZDOOM_ENABLE_SWR="$(usex swr)"
	)

	use debug || append-cppflags -DNDEBUG
	use telemetry || append-cppflags -DNO_SEND_STATS

	cmake_src_configure
}

src_install() {
	newicon src/posix/zdoom.xpm "${PN}.xpm"
	make_desktop_entry "${PN}" "GZDoom" "${PN}" "Game;ActionGame"
	cmake_src_install
}

pkg_postinst() {
	xdg_pkg_postinst
}

# vim: noet ts=4 syn=ebuild