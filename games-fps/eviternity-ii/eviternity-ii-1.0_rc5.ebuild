# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Eviternity II is a full 36-map megawad sequel to Eviternity; comprised of six 5-map Chapters, each with an additional secret level; it was created as a 30th birthday gift to Doom."
HOMEPAGE="https://eviternity.dfdoom.com/"
SRC_URI="https://eviternity-dl-eu.dfdoom.com/Eviternity-II.zip -> Eviternity-II.zip"

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
	elog "A Doom engine is required in order to play the Eviternity II RC5.wad file."
}