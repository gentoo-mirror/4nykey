# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="Sofia-Sans"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lettersoup/${MY_PN}.git"
else
	MY_PV="cba178c"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV/_/-}"
	SRC_URI="
		mirror://githubcl/lettersoup/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${MY_PV#v}"
fi
inherit fontmake

DESCRIPTION="A comprehensive type system with extended coverage of the LGC Script"
HOMEPAGE="https://github.com/lettersoup/${MY_PN}"

LICENSE="OFL-1.1"
SLOT="0"
REQUIRED_USE+="
	binary? ( variable? ( !font_types_otf ) )
"

pkg_setup() {
	use font_types_ttf && use !variable && FONTDIR_BIN=( fonts/ttf/static )
	fontmake_pkg_setup
}
