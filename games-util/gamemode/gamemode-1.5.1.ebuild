# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson ninja-utils user

DESCRIPTION="Optimise Linux system performance on demand"
HOMEPAGE="https://github.com/FeralInteractive/gamemode"

GAMEMODE_GIT_PTR="${PV}"
SRC_URI="https://github.com/FeralInteractive/gamemode/releases/download/${GAMEMODE_GIT_PTR}/${P}.tar.xz"
KEYWORDS="*"

LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	sys-auth/elogind
	sys-auth/polkit
	dev-libs/inih
"
DEPEND="${RDEPEND}"

PATCHES=("${FILESDIR}/pull-228-elogind-support.patch")

pkg_pretend() {
	elog
	elog "GameMode needs a kernel capable of SCHED_ISO to use its soft realtime"
	elog "feature. Examples of kernels providing that are sys-kernel/ck-source"
	elog "and sys-kernel/pf-sources."
	elog
	elog "Support for soft realtime is completely optional. It may provide the"
	elog "following benefits with systems having at least four CPU cores:"
	elog
	elog "  * more CPU shares allocated exclusively to the game"
	elog "  * reduced input lag and reduced thread latency"
	elog "  * more consistent frame times resulting in less microstutters"
	elog
	elog "You probably won't benefit from soft realtime mode and thus don't need"
	elog "SCHED_ISO if:"
	elog
	elog "  * Your CPU has less than four cores because the game may experience"
	elog "    priority inversion with the graphics driver (thus heuristics"
	elog "    automatically disable SCHED_ISO usage then)"
	elog "  * Your game uses busy-loops to interface with the graphics driver"
	elog "    but you may still force SCHED_ISO per configuation file, YMMV,"
	elog "    it depends on the graphics driver implementation, i.e. usage of"
	elog "    __GL_THREADED_OPTIMIZATIONS or similar."
	elog "  * If your game causes more than 70% CPU usage across all cores,"
	elog "    SCHED_ISO automatically turns off and on depending on usage and"
	elog "    is processed with higher-than-normal priority then (renice)."
	elog "    This auto-switching may result in a lesser game experience."
	elog
	elog "For more info look at:"
	elog "https://github.com/FeralInteractive/gamemode/blob/${GAMEMODE_GIT_PTR}/README.md"
	elog
}

src_configure() {
	local emesonargs=(
		-Dwith-sd-bus-provider="elogind"
	)

	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
}

pkg_postinst() {
	enewgroup gamemode

	elog
	elog "GameMode can renice your games. You need to be in the gamemode group for this to work."
	elog "Run the following command as root to add your user:"
	elog "# gpasswd -a USER gamemode  # with USER = your user name"
	elog

	elog "Enable and start the daemon in your systemd user instance,"
	elog "or simply run 'gamemoded -d' if using OpenRC, then add"
	elog "gamemoderun %command%"
	elog "to the start options of any steam game to enable the performance"
	elog "governor as you start the game."
	elog
}
