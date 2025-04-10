# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/LettError/${PN}.git"
else
	MY_PV="${PV}"
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="ac9af54"
	fi
	SRC_URI="
		mirror://githubcl/LettError/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
fi

DESCRIPTION="A library for piecewise linear interpolation in multiple dimensions"
HOMEPAGE="https://github.com/LettError/${PN}"

LICENSE="BSD"
SLOT="0"

RDEPEND="
	>=dev-python/fonttools-3.32[ufo(-),${PYTHON_USEDEP}]
	dev-python/defcon[${PYTHON_USEDEP}]
	dev-python/fontMath[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

python_test() {
	"${EPYTHON}" Lib/mutatorMath/test/run.py -v
}
