# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A complete free-content single-player focused game based on the Doom engine"
HOMEPAGE="https://freedoom.github.io"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	=games-fps/freedoom-data-${PV}
	|| (
		games-engines/gzdoom
		games-engines/odamex
		games-fps/doomsday
	)
"

pkg_postinst() {
	elog "If you are looking for a multiplayer-focused deathmatch game, please install games-fps/freedm."
}

# vim: noet ts=4 syn=ebuild