# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VALA_MIN_API_VERSION="0.42"
VALA_USE_DEPEND="vapigen"
inherit vala meson xdg
MY_GNOME="${PV:2:2}"
MY_GNOME="${PV%%.*}.$((MY_GNOME+MY_GNOME%2))"
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Keruspe/GPaste.git"
	EGIT_BRANCH="${PN}-${MY_GNOME}"
	SRC_URI=""
else
	SRC_URI="https://www.imagination-land.org/files/${PN}/${P}.tar.xz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Clipboard management system"
HOMEPAGE="https://github.com/Keruspe/GPaste"

LICENSE="BSD-2"
SLOT="0"
IUSE="bash-completion gnome-shell introspection systemd vala zsh-completion"
REQUIRED_USE="
	vala? ( introspection )
"

DEPEND="
	>=dev-libs/glib-2.58:2
	>=x11-libs/gtk+-3.24:3[introspection?]
	>=x11-libs/gdk-pixbuf-2.38[introspection?]
	vala? ( $(vala_depend) )
	introspection? (
		>=dev-libs/gobject-introspection-1.58
		>=x11-wm/mutter-3.36:0/6[introspection]
	)
	>=dev-libs/gjs-1.54
	systemd? ( sys-apps/systemd )
"
RDEPEND="
	${DEPEND}
	dev-libs/appstream-glib
	gnome-base/gnome-control-center:2
	sys-apps/dbus
	gnome-shell? ( gnome-base/gnome-shell )
"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
"

src_prepare() {
	use vala && vala_src_prepare
	default
}

src_configure() {
	local emesonargs=(
		$(meson_use bash-completion)
		$(meson_use introspection)
		$(meson_use gnome-shell)
		$(meson_use systemd)
		$(meson_use vala vapi)
		$(meson_use zsh-completion)
	)
	meson_src_configure
}
