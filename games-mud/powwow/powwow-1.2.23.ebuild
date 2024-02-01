# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils

DESCRIPTION="PowWow Console MUD Client"
HOMEPAGE="https://www.hoopajoo.net/projects/powwow.html"
SRC_URI="https://github.com/MUME/powwow/tarball/57cc8e95ac7f96ff6eae17b46edc60b01f2d0e0a -> powwow-1.2.23-57cc8e9.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

BDEPEND="virtual/pkgconfig"
DEPEND="sys-libs/ncurses:0="
RDEPEND="${DEPEND}"
PATCHES=(
	"${FILESDIR}"/"${PN}-1.2.22-linking.patch"
)

S="${WORKDIR}/MUME-powwow-57cc8e9"

src_prepare() {
	default

	# note that that the extra, seemingly-redundant files installed are
	# actually used by in-game help commands
	sed -i \
		-e "s/pkgdata_DATA = powwow.doc/pkgdata_DATA = /" \
		Makefile.am || die
	eautoreconf
}

src_configure() {
	econf --includedir=/usr/include
}


src_install() {
	local DOCS=( Hacking powwow.doc powwow.help README.* TODO )
	# Prepend doc/
	DOCS=( ${DOCS[@]/#/doc\//} )
	# Add in the root items
	DOCS+=( ChangeLog.old NEWS )

	default
}