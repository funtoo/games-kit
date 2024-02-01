# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="⚔️ A cross-platform, open source, and super fast MUD client with scripting in Lua"
HOMEPAGE="https://www.mudlet.org https://github.com/Mudlet/Mudlet"
SRC_URI="https://github.com/Mudlet/Mudlet/tarball/5b5712127f98ac25b802eefa582cff274b2f79b5 -> Mudlet-4.17.1-5b57121.tar.gz"

LICENSE="GPL-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="
	app-text/hunspell
	dev-lang/lua
	dev-libs/libzip
	dev-libs/yajl
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/designer:5
	dev-libs/qtkeychain
	sys-libs/zlib
	virtual/glu
	dev-libs/pugixml
"
RDEPEND="${DEPEND}
	dev-lua/luafilesystem
"

# some lua modules might need to be installed by the user in order for
# scripting to be completely functional; these are not in our tree:
	#dev-lua/lrexlib[pcre]
	#dev-lua/luasql[sqlite3]
	#dev-lua/luazip

BDEPEND=""

EGIT_REPO_URI="https://github.com/Mudlet/Mudlet"
EGIT_COMMIT="Mudlet-${PV}"

src_prepare() {
	git-r3_checkout
	cmake_src_prepare
	einfo after updating
}

src_configure() {
	local mycmakeargs=(
		-DQS_LOG_IS_SHARED_LIBRARY=OFF
	)
	WITH_OWN_QTKEYCHAIN=NO WITH_SYSTEM_QTKEYCHAIN=YES cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
}

# vim: syn=ebuild ts=4 noet