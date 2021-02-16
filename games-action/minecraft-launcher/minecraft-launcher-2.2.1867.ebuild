# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg

DESCRIPTION="An open-world game whose gameplay revolves around breaking and placing blocks"
HOMEPAGE="https://www.minecraft.net/"
SRC_URI="https://launcher.mojang.com/download/linux/x86_64/minecraft-launcher_2.2.1867.tar.gz"

KEYWORDS="amd64"
LICENSE="Mojang"
SLOT="2"

RESTRICT="bindist mirror"

DEPEND="dev-util/patchelf"
RDEPEND="
	>=x11-libs/gtk+-2.24.32-r1[X]
	dev-libs/nss
	dev-libs/libbsd
	dev-libs/libffi
	dev-libs/libpcre
	media-libs/alsa-lib
	media-libs/openal
	net-libs/gnutls[idn]
	net-print/cups
	sys-apps/dbus
	virtual/jre:1.8
	virtual/opengl
	x11-apps/xrandr
	x11-libs/libXScrnSaver
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/xcb-util
"

S="${WORKDIR}/${PN}"

QA_PRESTRIPPED="
	/opt/minecraft-launcher/libcef.so
	/opt/minecraft-launcher/liblauncher.so
	/opt/minecraft-launcher/minecraft-launcher
"

src_install() {
	dodir /opt/${PN}
	insinto /opt/${PN}/
	patchelf --set-rpath '$ORIGIN' libcef.so liblauncher.so "${PN}"
	doins -r .
	fperms +x /opt/${PN}/${PN}
	dosym ../${PN}/${PN} /opt/bin/${PN}
	doicon -s scalable "${FILESDIR}/${PN}.svg"
	make_desktop_entry ${PN} "Minecraft" ${PN} Game
}

pkg_postinst() {
	xdg_icon_cache_update
	einfo "This package has installed the Java Minecraft launcher."
	einfo "To actually play the game, you need to purchase an account at:"
	einfo "    ${HOMEPAGE}"
}

pkg_postrm() {
	xdg_icon_cache_update
}