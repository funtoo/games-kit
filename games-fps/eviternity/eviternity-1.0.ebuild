# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Eviternity is a megawad comprised of six 5-map episodes (called Chapters) plus two secret maps, created as a 25th birthday gift to Doom."
HOMEPAGE="https://www.doomworld.com/idgames/levels/doom2/Ports/megawads/eviternity"
SRC_URI="https://youfailit.net/pub/idgames/levels/doom2/Ports/megawads/eviternity.zip -> eviternity.zip"

LICENSE="freedist"
SLOT="0"
KEYWORDS="*"

S="${DISTDIR}"

DOOMWADPATH="/usr/share/doom"

src_install() {
	insinto ${DOOMWADPATH}
	doins ${WORKDIR}/*.{wad,txt}
}

pkg_postinst() {
	elog "Doom WAD file installed into the ${DOOMWADPATH} directory."
	elog "A Doom engine is required in order to play the Eviternity.wad file."
}