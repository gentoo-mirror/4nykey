# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit qmake-utils python-single-r1 xdg-utils vcs-snapshot
if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/MrKepzie/${PN}.git"
	EGIT_BRANCH="RB-${PV%.*}"
	inherit git-r3
else
	MY_PV="9ddf069"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	MY_OFX='openfx-3056fd6'
	MY_SEQ='SequenceParsing-4b5e605'
	MY_TIN='tinydir-60f0905'
	MY_MCK='google-mock-17945db'
	MY_TST='google-test-50d6fc3'
	SRC_URI="
		mirror://githubcl/MrKepzie/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/devernay/${MY_OFX%-*}/tar.gz/${MY_OFX##*-}
		-> ${MY_OFX}.tar.gz
		mirror://githubcl/MrKepzie/${MY_SEQ%-*}/tar.gz/${MY_SEQ##*-}
		-> ${MY_SEQ}.tar.gz
		mirror://githubcl/MrKepzie/${MY_TIN%-*}/tar.gz/${MY_TIN##*-}
		-> ${MY_TIN}.tar.gz
		test? (
			mirror://githubcl/MrKepzie/${MY_MCK%-*}/tar.gz/${MY_MCK##*-}
			-> ${MY_MCK}.tar.gz
			mirror://githubcl/MrKepzie/${MY_TST%-*}/tar.gz/${MY_TST##*-}
			-> ${MY_TST}.tar.gz
		)
	"
	KEYWORDS="~amd64 ~x86"
fi
MY_OC="OpenColorIO-Configs_${PN^}-v${PV%.*}"
SRC_URI+="
	mirror://githubcl/MrKepzie/${MY_OC%%_*}/tar.gz/${MY_OC#*_}
	-> ${MY_OC}.tar.gz
"
RESTRICT="primaryuri"

DESCRIPTION="Open-source video compositing software"
HOMEPAGE="https://natron.fr"

LICENSE="GPL-2+ doc? ( CC-BY-SA-4.0 )"
SLOT="0"
IUSE="c++11 debug doc openmp pch test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/boost
	media-libs/fontconfig
	dev-libs/expat
	x11-libs/cairo[static-libs]
	dev-python/pyside:0[X,opengl,${PYTHON_USEDEP}]
	dev-python/shiboken:0[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	doc? ( dev-python/sphinx )
"
RDEPEND="
	${RDEPEND}
	media-plugins/openfx-io
	media-plugins/openfx-misc
	media-plugins/openfx-arena
"

src_unpack() {
	[[ -z ${PV%%*9999} ]] && git-r3_src_unpack
	vcs-snapshot_src_unpack
}

src_prepare() {
	default

	if [[ -n ${PV%%*9999} ]]; then
		mv "${WORKDIR}"/${MY_OFX}/* "${S}"/libs/OpenFX
		mv "${WORKDIR}"/${MY_SEQ}/* "${S}"/libs/SequenceParsing
		mv "${WORKDIR}"/${MY_TIN}/* "${S}"/libs/SequenceParsing/tinydir
		if use test; then
			mv "${WORKDIR}"/${MY_MCK}/* "${S}"/Tests/${MY_MCK%-*}
			mv "${WORKDIR}"/${MY_TST}/* "${S}"/Tests/${MY_TST%-*}
		fi
	fi
	mv "${WORKDIR}"/${MY_OC} "${S}"/OpenColorIO-Configs

	sed \
		-e "s:@PKGCONFIG@:$(tc-getPKG_CONFIG):" \
		"${FILESDIR}"/config.pri > "${S}"/config.pri

	sed \
		-e '/INCLUDEPATH.*OSMESA_INCLUDES/d' \
		-i global.pri
}

src_configure() {
	local qmakeargs=(
		PREFIX=/usr
		BUILD_USER_NAME=Gentoo
		CONFIG+=custombuild
		CONFIG$(usex c++11 + -)=c++11
		CONFIG$(usex openmp + -)=openmp
		CONFIG$(usex pch - +)=nopch
		CONFIG$(usex debug - +)=noassertions
		CONFIG$(usex test - +)=notests
	)
	eqmake4 -r "${qmakeargs[@]}"
}

src_compile() {
	default
	use doc && \
		sphinx-build -b html Documentation/source html
}

src_install() {
	local DOCS=(
		{BUGS,CHANGELOG,CONTRIBUTING,README}.md CONTRIBUTORS.txt
		$(usex doc html '')
	)
	emake INSTALL_ROOT="${ED}" install
	einstalldocs
}

src_test() {
	cd "${S}"/Tests
	./Tests || die
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
