# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/alexeiva/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="9fe3b99"
	SRC_URI="
		mirror://githubcl/alexeiva/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A geometric slab-serif typeface family suited for screen and print"
HOMEPAGE="https://github.com/alexeiva/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="interpolate"

src_prepare() {
	rm -f sources/'Arvo Italic source.glyphs'
	fontmake_src_prepare
}
