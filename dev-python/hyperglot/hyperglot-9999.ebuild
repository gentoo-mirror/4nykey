# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rosettatype/${PN}.git"
else
	MY_PV="c465e95"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/rosettatype/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi
inherit distutils-r1

DESCRIPTION="A database and tools for detecting language support in fonts"
HOMEPAGE="http://hyperglot.rosettatype.com"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	dev-python/fonttools[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/unicodedata2[${PYTHON_USEDEP}]
	dev-python/colorlog[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
distutils_enable_tests pytest
