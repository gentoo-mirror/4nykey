# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python eutils

DESCRIPTION="SDict Viewer is a viewer for sdict.com dictionaries"
HOMEPAGE="http://sdictviewer.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"
S="${WORKDIR}/${PN}/src"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="
	>=virtual/python-2.4
	>=dev-python/pygtk-2.6
"

DEST="/usr/lib/${PN}"

dolauncher() {
cat << EOF > ${T}/${PN}
#!/bin/sh
/usr/bin/python ${DEST}/sdictview.py
EOF
dobin ${T}/${PN}
}

src_install() {
	dolauncher
	insinto ${DEST}
	doins *.py
	make_desktop_entry ${PN} "SDict Viewer" gnome-dictionary
}

pkg_postinst() {
	python_mod_optimize ${ROOT}${DEST}
}

pkg_postrm() {
	python_mod_cleanup ${ROOT}${DEST}
}
