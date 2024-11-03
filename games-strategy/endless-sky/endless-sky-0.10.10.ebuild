# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_9 )
inherit python-any-r1 scons-utils xdg #toolchain-funcs xdg

DESCRIPTION="Space exploration, trading & combat in the tradition of Terminal Velocity"
HOMEPAGE="https://endless-sky.github.io"
SRC_URI="https://github.com/endless-sky/endless-sky/tarball/88820be195f686eda8ecc794996873c18e4f2c2f -> endless-sky-0.10.10-88820be.tar.gz"

LICENSE="CC-BY-SA-4.0 CC-BY-SA-3.0 GPL-3+ public-domain"
SLOT="0"
KEYWORDS="*"
IUSE="gles2-only"

RDEPEND="
	media-libs/libjpeg-turbo:=
	media-libs/libmad
	media-libs/libpng:=
	media-libs/openal
	sys-apps/util-linux
	gles2-only? (
		media-libs/libglvnd
		media-libs/libsdl2[gles2,video]
	)
	!gles2-only? (
		media-libs/glew:0=
		media-libs/libglvnd[X]
		media-libs/libsdl2[opengl,video]
	)"
DEPEND="${RDEPEND}"

S="${WORKDIR}/endless-sky-endless-sky-88820be"
PATCHES=(
	"${FILESDIR}"/"${PN}-0.9.16.1-respect-cflags.patch"
	"${FILESDIR}"/"${PN}-0.9.14-no-games-path.patch"
)


src_compile() {
#	tc-export AR CXX

	MYSCONSARGS=(
		PREFIX="${EPREFIX}"/usr
		opengl=$(usex gles2-only gles desktop)
	)

	escons "${MYSCONSARGS[@]}"
}

src_test() {
	# TODO: unbundle dev-cpp/catch if upstream migrates to catch v3
	escons "${MYSCONSARGS[@]}" test
}

src_install() {
	escons "${MYSCONSARGS[@]}" DESTDIR="${D}" install
}

pkg_postinst() {
	xdg_pkg_postinst

	einfo "Endless Sky provides high-res sprites for high-dpi screens."
	einfo "If you want to use them, download"
	einfo
	einfo "   https://github.com/endless-sky/endless-sky-high-dpi/releases"
	einfo
	einfo "and extract it to ~/.local/share/endless-sky/plugins/."
	einfo
	einfo "Enjoy."
}

# vim: noet ts=4 syn=ebuild