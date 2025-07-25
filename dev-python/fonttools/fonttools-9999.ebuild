# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="xml(+)"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 optfeature
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	[[ -z ${PV%%*_p*} ]] && MY_PV="66d847e"
	MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/${PN}/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="Library for manipulating TrueType, OpenType, AFM and Type1 fonts"
HOMEPAGE="https://github.com/${PN}/${PN}"

LICENSE="BSD"
SLOT="0"
IUSE="doc graphite harfbuzz interpolatable plot png qt5 reportlab skia +ufo +unicode woff"
DOCS=( {README,NEWS}.rst )
PATCHES=(
	"${FILESDIR}"/${PN}-xattr.diff
)

# README.rst: Optional Requirements
RDEPEND="
	>=dev-python/lxml-5.3[${PYTHON_USEDEP}]
	>=app-arch/brotli-1.1[python,${PYTHON_USEDEP}]
	woff? (
		>=dev-python/py-zopfli-0.2.3[${PYTHON_USEDEP}]
	)
	unicode? (
		>=dev-python/unicodedata2-15.1[${PYTHON_USEDEP}]
	)
	qt5? ( dev-python/pyqt5[${PYTHON_USEDEP}] )
	graphite? ( dev-python/lz4[${PYTHON_USEDEP}] )
	plot? ( dev-python/matplotlib[${PYTHON_USEDEP}] )
	interpolatable? ( >=dev-python/scipy-1.14.1[${PYTHON_USEDEP}] )
	reportlab? ( dev-python/reportlab[${PYTHON_USEDEP}] )
	skia? ( >=dev-python/skia-pathops-0.8[${PYTHON_USEDEP}] )
	>=dev-python/freetype-py-2.5.1[${PYTHON_USEDEP}]
	harfbuzz? ( >=dev-python/uharfbuzz-0.43[${PYTHON_USEDEP}] )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		>=dev-python/ufoLib2-0.17[${PYTHON_USEDEP}]
		>=dev-python/ufo2ft-3.3.1[${PYTHON_USEDEP}]
		>=dev-python/glyphsLib-6.9.5[${PYTHON_USEDEP}]
	)
"
distutils_enable_sphinx Doc/source dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	distutils-r1_python_test
}

pkg_postinst() {
	optfeature "symbolic font statistics analysis" dev-python/sympy
}
