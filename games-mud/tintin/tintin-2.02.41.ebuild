# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="(T)he k(I)cki(N) (T)ickin d(I)kumud clie(N)t"
HOMEPAGE="https://tintin.mudhalla.net"
SRC_URI="https://github.com/scandum/tintin/tarball/84ca426c77b31f53539f09b409562fcde4e6d2b2 -> tintin-2.02.41-84ca426.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"

DEPEND="
	dev-libs/libpcre
	net-libs/gnutls
	sys-libs/readline:0
	sys-libs/zlib"
RDEPEND=${DEPEND}

#S=${WORKDIR}/tt/src
S="${WORKDIR}/scandum-tintin-84ca426/src"

src_install() {
	dobin tt++
	dodoc ../{CREDITS,FAQ,README,SCRIPTS,TODO,docs/*}
}

pkg_postinst() {
	ewarn "**** OLD TINTIN SCRIPTS ARE NOT 100% COMPATIBLE WITH THIS VERSION ****"
	ewarn "read the README for more details."
}
# vim: noet ts=4 syn=ebuild