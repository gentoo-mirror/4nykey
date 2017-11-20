# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/devernay/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="1e07155"
	[[ -n ${PV%%*_p*} ]] && MY_PV="Natron-${PV}"
	MY_OFX='openfx-276eddf'
	MY_SUP='openfx-supportext-f2aa65e'
	SRC_URI="
		mirror://githubcl/devernay/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/devernay/${MY_OFX%-*}/tar.gz/${MY_OFX##*-} -> ${MY_OFX}.tar.gz
		mirror://githubcl/devernay/${MY_SUP%-*}/tar.gz/${MY_SUP##*-} -> ${MY_SUP}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Miscellaneous OpenFX plugins for Natron"
HOMEPAGE="https://github.com/devernay/${PN}"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="
	virtual/opengl
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	if [[ -n ${PV%%*9999} ]]; then
		mv "${WORKDIR}"/${MY_OFX}/* "${S}"/openfx
		mv "${WORKDIR}"/${MY_SUP}/* "${S}"/SupportExt
	fi
}

src_compile() {
	local myemakeargs=(
		CXX=$(tc-getCXX)
		CXXFLAGS_ADD="${CXXFLAGS}"
		LDFLAGS_ADD="${LDFLAGS}"
		V=1
	)
	emake "${myemakeargs[@]}"
}
