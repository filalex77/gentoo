# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils

DESCRIPTION="rxvt clone with xft and unicode support"
HOMEPAGE="http://software.schmorp.de/pkg/rxvt-unicode.html"
SRC_URI="http://dist.schmorp.de/rxvt-unicode/Attic/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"
IUSE="
	256-color blink fading-colors +font-styles gdk-pixbuf iso14755 +mousewheel
	+perl startup-notification unicode3 xft
"
RESTRICT="test"

RDEPEND="
	>=sys-libs/ncurses-5.7-r6:=
	kernel_Darwin? ( dev-perl/Mac-Pasteboard )
	media-libs/fontconfig
	perl? ( dev-lang/perl:= )
	gdk-pixbuf? ( x11-libs/gdk-pixbuf x11-libs/gtk+:2 )
	startup-notification? ( x11-libs/startup-notification )
	x11-libs/libX11
	x11-libs/libXrender
	xft? ( x11-libs/libXft )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto
"
PATCHES=(
	"${FILESDIR}"/${PN}-9.06-case-insensitive-fs.patch
	"${FILESDIR}"/${PN}-9.21-xsubpp.patch
)

src_prepare() {
	default

	# kill the rxvt-unicode terminfo file - #192083
	sed -i -e "/rxvt-unicode.terminfo/d" doc/Makefile.in || die "sed failed"

	eautoreconf
}

src_configure() {
	# --enable-everything goes first: the order of the arguments matters
	econf \
		--enable-everything \
		$(use_enable 256-color) \
		$(use_enable blink text-blink) \
		$(use_enable fading-colors fading) \
		$(use_enable font-styles) \
		$(use_enable gdk-pixbuf pixbuf) \
		$(use_enable iso14755) \
		$(use_enable mousewheel) \
		$(use_enable perl) \
		$(use_enable startup-notification) \
		$(use_enable unicode3) \
		$(use_enable xft)
}

src_compile() {
	default

	sed -i \
		-e 's/RXVT_BASENAME = "rxvt"/RXVT_BASENAME = "urxvt"/' \
		"${S}"/doc/rxvt-tabbed || die
}

src_install() {
	default

	dodoc \
		README.FAQ Changes doc/README* doc/changes.txt doc/etc/* doc/rxvt-tabbed

	make_desktop_entry urxvt rxvt-unicode utilities-terminal \
		"System;TerminalEmulator"
}
