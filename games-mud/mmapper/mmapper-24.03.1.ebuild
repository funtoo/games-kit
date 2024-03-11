# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR=emake
inherit cmake

DESCRIPTION="🧙‍♂️ MMapper is a graphical MUD client for the game MUME (Multi-Users in Middle-earth)"
HOMEPAGE="https://mume.github.io/MMapper/"
SRC_URI="https://github.com/MUME/MMapper/tarball/7842a1055ba73c3eaee466d346ac6c4b634c412e -> MMapper-24.03.1-7842a10.tar.gz"

LICENSE="GPL-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="+map upnp"

DEPEND="
	upnp? ( net-libs/miniupnpc )
"
RDEPEND="${DEPEND}"
BDEPEND=""

# necessary for downloading the map and build dependencies
RESTRICT="network-sandbox"

S="${WORKDIR}/MUME-MMapper-7842a10"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	# from the official install guide:
	# -DWITH_MAP=OFF if not use map
	# cmake -DPREFIX=${EPREFIX}/usr -DWITH_MINIUPNPC=OFF -S ..
	local mycmakeargs=(
		$(use upnp || echo -DWITH_MINIUPNPC=OFF)
		$(use map || echo -DWITH_MAP=OFF)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
}

# vim: syn=ebuild ts=4 noet