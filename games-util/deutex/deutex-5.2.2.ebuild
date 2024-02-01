# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs eutils

DESCRIPTION="A wad composer for Doom, Heretic, Hexen and Strife"
HOMEPAGE="http://www.teaser.fr/~amajorel/deutex/"
SRC_URI="https://github.com/Doom-Utils/deutex/tarball/e83e25268b866bf588ef839a155114208df5833a -> deutex-5.2.2-e83e252.tar.gz"

LICENSE="GPL-2+ LGPL-2+ HPND"
SLOT="0"
KEYWORDS="*"
IUSE="doc"

RDEPEND=""
DEPEND="doc? ( app-text/asciidoc )"

S="${WORKDIR}/Doom-Utils-deutex-e83e252"


src_prepare() {
	./bootstrap
	default
}

src_install() {
	dobin src/deutex
	use doc && doman man/deutex.6
	dodoc AUTHORS COPYING COPYING.LIB LICENSE NEWS.adoc README.adoc
}

# vim: ts=4 noet syn=ebuild