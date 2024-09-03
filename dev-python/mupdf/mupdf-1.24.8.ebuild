# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Please check upstream git regularly for relevant security-related commits
# to backport.

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
inherit distutils-r1

DESCRIPTION="A lightweight PDF viewer and toolkit written in portable C"
HOMEPAGE="https://mupdf.com/ https://git.ghostscript.com/?p=mupdf.git"
SRC_URI="https://mupdf.com/downloads/archive/${P}-source.tar.gz"
S="${WORKDIR}/${P}-source"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	~app-text/mupdf-${PV}
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-python/clang-python[${PYTHON_USEDEP}]
	dev-lang/swig
"
PATCHES=(
	"${FILESDIR}"/python.diff
)
distutils_enable_tests pytest

python_prepare_all() {
	python_setup
	distutils-r1_python_prepare_all
}

_buildpy() {
	"${EPYTHON}" ./scripts/mupdfwrap.py \
		-d "build/shared-release-${EPYTHON}" "${@}" || die
}

python_compile() {
	_buildpy -b 23
}

src_compile() {
	# libmupdfcpp
	"${EPYTHON}" ./scripts/mupdfwrap.py \
		-d "build/shared-release" -b 01 || die
	mv build/shared-release/libmupdfcpp.so{,.${PV}} .
	# _mupdf.so
	distutils-r1_src_compile
}

python_test() {
	local -x LD_LIBRARY_PATH="${S}"
	_buildpy --test-python
}

python_install() {
	python_domodule \
		build/shared-release-${EPYTHON}/{_mupdf.so,mupdf.py}
}

python_install_all() {
	dolib.so libmupdfcpp.so*
	doheader -r platform/c++/include/mupdf
}
