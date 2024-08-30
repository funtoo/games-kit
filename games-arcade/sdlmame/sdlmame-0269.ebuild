# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9,10})

inherit desktop python-any-r1 toolchain-funcs qmake-utils xdg-utils

DESCRIPTION="MAME is a multi-purpose emulation framework. MAME’s purpose is to preserve decades of software history. MAME now documents a wide variety of (mostly vintage) computers, video game consoles and calculators, in addition to the arcade video games"
HOMEPAGE="https://github.com/mamedev/mame http://mamedev.org/"
SRC_URI="https://github.com/mamedev/mame/tarball/4e56bc48e66219ed259f7a4c258a86853fc7ea25 -> mame-0269-4e56bc4.tar.gz"

LICENSE="GPL-2+ BSD-2 MIT CC0-1.0"
SLOT="0"
KEYWORDS="amd64"
IUSE="alsa debug opengl openmp tools"

RDEPEND="dev-db/sqlite:3
	dev-libs/expat
	media-libs/fontconfig
	media-libs/flac
	media-libs/libsdl2[joystick,opengl?,sound,video,X]
	media-libs/portaudio
	media-libs/sdl2-ttf
	sys-libs/zlib
	virtual/jpeg:0
	virtual/opengl
	alsa? ( media-libs/alsa-lib
		media-libs/portmidi )
	 debug? ( dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5 )
	x11-libs/libX11
	x11-libs/libXinerama
	>=dev-cpp/asio-1.28.0
	dev-libs/libutf8proc
	media-libs/glm
	dev-libs/rapidjson
	dev-libs/pugixml"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto"

post_src_unpack() {
	if [ ! -d "${S}" ] ; then
	mv ${WORKDIR}/mamedev-mame-* ${S} || die
	fi
}

# Function to disable a makefile option
disable_feature() {
	sed -i -e "/^[ 	]*$1.*=/s:^:# :" makefile || die
}

# Function to enable a makefile option
enable_feature() {
	sed -i -e "/^#.*$1.*=/s:^#[ 	]*::"  makefile || die
}

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	default
	# Disable using bundled libraries
	enable_feature USE_SYSTEM_LIB_ASIO
	enable_feature USE_SYSTEM_LIB_UTF8PROC
	enable_feature USE_SYSTEM_LIB_GLM
	enable_feature USE_SYSTEM_LIB_RAPIDJSON
	enable_feature USE_SYSTEM_LIB_PUGIXML
	enable_feature USE_SYSTEM_LIB_EXPAT
	enable_feature USE_SYSTEM_LIB_FLAC
	enable_feature USE_SYSTEM_LIB_JPEG
# Use bundled lua for now to ensure correct compilation (ref. b.g.o #407091)
#	enable_feature USE_SYSTEM_LIB_LUA
	enable_feature USE_SYSTEM_LIB_PORTAUDIO
	enable_feature USE_SYSTEM_LIB_SQLITE3
	enable_feature USE_SYSTEM_LIB_ZLIB

	# Disable warnings being treated as errors and enable verbose build output
	enable_feature NOWERROR
	enable_feature VERBOSE
	enable_feature IGNORE_GIT

	use amd64 && enable_feature PTR64
	use debug && enable_feature DEBUG
	use tools && enable_feature TOOLS
	disable_feature NO_X11 # bgfx needs X
	use openmp && enable_feature OPENMP

	if use alsa ; then
		enable_feature USE_SYSTEM_LIB_PORTMIDI
	else
		enable_feature NO_USE_MIDI
	fi

	sed -i \
		-e 's/-Os//' \
		-e '/^\(CC\|CXX\|AR\) /s/=/?=/' \
		3rdparty/genie/build/gmake.linux/genie.make || die
}

src_compile() {
	local targetargs
	local qtdebug=$(usex debug 1 0)

	function my_emake() {
		# Workaround conflicting $ARCH variable used by both Gentoo's
		# portage and by Mame's build scripts
		PYTHON_EXECUTABLE=${PYTHON} \
		OVERRIDE_CC=$(tc-getCC) \
		OVERRIDE_CXX=$(tc-getCXX) \
		OVERRIDE_LD=$(tc-getCXX) \
		QT_SELECT=qt5 \
		QT_HOME="$(qt5_get_libdir)/qt5" \
		ARCH= \
			emake "$@" \
				AR=$(tc-getAR)
	}
	my_emake -j1 generate

	my_emake ${targetargs} \
		SDL_INI_PATH="\$\$\$\$HOME/.sdlmame;/etc/${PN}" \
		USE_QTDEBUG=${qtdebug}
}

src_install()
{
	MAMEBIN=mame
	dobin $MAMEBIN
	doman docs/man/mame.6

	insinto "/usr/share/${PN}"
	doins -r keymaps hash

	# Create default mame.ini and inject Gentoo settings into it
	#  Note that '~' does not work and '$HOME' must be used
	./${MAMEBIN} -noreadconfig -showconfig > "${T}/mame.ini" || die
	# -- Paths --
	for f in {rom,hash,sample,art,font,crosshair} ; do
		sed -i \
			-e "s:\(${f}path\)[ \t]*\(.*\):\1 \t\t\$HOME/.${PN}/\2;/usr/share/${PN}/\2:" \
			"${T}/mame.ini" || die
	done
	for f in {ctrlr,cheat} ; do
		sed -i \
			-e "s:\(${f}path\)[ \t]*\(.*\):\1 \t\t\$HOME/.${PN}/\2;/etc/${PN}/\2;/usr/share/${PN}/\2:" \
			"${T}/mame.ini" || die
	done
	# -- Directories
	for f in {cfg,nvram,memcard,input,state,snapshot,diff,comment} ; do
		sed -i \
			-e "s:\(${f}_directory\)[ \t]*\(.*\):\1 \t\t\$HOME/.${PN}/\2:" \
			"${T}/mame.ini" || die
	done
	# -- Keymaps --
	sed -i \
		-e "s:\(keymap_file\)[ \t]*\(.*\):\1 \t\t\$HOME/.${PN}/\2:" \
		"${T}/mame.ini" || die
	for f in keymaps/km*.map ; do
		sed -i \
			-e "/^keymap_file/a \#keymap_file \t\t/usr/share/${PN}/keymaps/${f##*/}" \
			"${T}/mame.ini" || die
	done
	insinto "/etc/${PN}"
	doins "${T}/mame.ini"

	insinto "/etc/${PN}"
	doins "${FILESDIR}/vector.ini"

	#dodoc docs/{config,mame,newvideo}.txt
	keepdir \
		"/usr/share/${PN}"/{ctrlr,cheat,roms,samples,artwork,crosshair} \
		"/etc/${PN}"/{ctrlr,cheat}

	if use tools ; then
		for f in castool chdman floptool imgtool jedutil ldresample ldverify romcmp ; do
			newbin ${f} ${PN}-${f}
			newman docs/man/${f}.1 ${PN}-${f}.1
		done
		#newbin ldplayer${suffix} ${PN}-ldplayer
		#newman docs/man/ldplayer.1 ${PN}-ldplayer.1
	fi
}

pkg_postinst() {
	xdg_desktop_database_update

	elog "It is strongly recommended to change either the system-wide"
	elog "  /etc/${PN}/mame.ini or use a per-user setup at ~/.${PN}/mame.ini"
	elog
	if use opengl ; then
		elog "You built ${PN} with opengl support and should set"
		elog "\"video\" to \"opengl\" in mame.ini to take advantage of that"
		elog
		elog "For more info see http://wiki.mamedev.org"
	fi
}

pkg_postrm(){
	xdg_desktop_database_update
}
