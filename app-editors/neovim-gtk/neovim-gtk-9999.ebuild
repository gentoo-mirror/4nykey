# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick-0.7.20
	ansi_term-0.12.1
	anyhow-1.0.66
	async-trait-0.1.59
	atty-0.2.14
	autocfg-1.1.0
	bitflags-1.3.2
	build-version-0.1.1
	byteorder-1.4.3
	bytes-0.4.12
	bytes-1.3.0
	cairo-rs-0.16.7
	cairo-sys-rs-0.16.3
	cc-1.0.78
	cfg-expr-0.11.0
	cfg-if-1.0.0
	clap-2.34.0
	dirs-4.0.0
	dirs-sys-0.3.7
	env_logger-0.10.0
	errno-0.2.8
	errno-dragonfly-0.1.2
	field-offset-0.3.4
	fnv-1.0.7
	futures-0.1.31
	futures-0.3.25
	futures-channel-0.3.25
	futures-core-0.3.25
	futures-executor-0.3.25
	futures-io-0.3.25
	futures-macro-0.3.25
	futures-sink-0.3.25
	futures-task-0.3.25
	futures-util-0.3.25
	gdk-pixbuf-0.16.7
	gdk-pixbuf-sys-0.16.3
	gdk4-0.5.4
	gdk4-sys-0.5.4
	getrandom-0.1.16
	getrandom-0.2.8
	gio-0.16.7
	gio-sys-0.16.3
	glib-0.16.7
	glib-macros-0.16.3
	glib-sys-0.16.3
	gobject-sys-0.16.3
	graphene-rs-0.16.3
	graphene-sys-0.16.3
	gsk4-0.5.4
	gsk4-sys-0.5.4
	gtk4-0.5.4
	gtk4-macros-0.5.4
	gtk4-sys-0.5.4
	heck-0.4.0
	hermit-abi-0.1.19
	hermit-abi-0.2.6
	htmlescape-0.3.1
	humantime-2.1.0
	io-lifetimes-1.0.3
	iovec-0.1.4
	is-terminal-0.4.1
	itoa-1.0.4
	lazy_static-1.4.0
	libc-0.2.138
	linux-raw-sys-0.1.4
	lock_api-0.4.9
	log-0.4.17
	memchr-2.5.0
	memoffset-0.6.5
	mio-0.8.5
	num-traits-0.2.15
	num_cpus-1.14.0
	nvim-rs-0.4.0
	once_cell-1.16.0
	pango-0.16.5
	pango-sys-0.16.3
	parity-tokio-ipc-0.9.0
	parking_lot-0.12.1
	parking_lot_core-0.9.5
	paste-1.0.10
	percent-encoding-1.0.1
	pest-2.5.1
	phf-0.11.1
	phf_codegen-0.11.1
	phf_generator-0.11.1
	phf_shared-0.11.1
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	pkg-config-0.3.26
	ppv-lite86-0.2.17
	proc-macro-crate-1.2.1
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.47
	quick-error-1.2.3
	quote-1.0.21
	rand-0.7.3
	rand-0.8.5
	rand_chacha-0.2.2
	rand_core-0.5.1
	rand_core-0.6.4
	rand_hc-0.2.0
	redox_syscall-0.2.16
	redox_users-0.4.3
	regex-1.7.0
	regex-syntax-0.6.28
	rmp-0.8.11
	rmpv-1.0.0
	rustc_version-0.3.3
	rustix-0.36.5
	ryu-1.0.11
	scopeguard-1.1.0
	semver-0.11.0
	semver-parser-0.10.2
	serde-1.0.151
	serde_bytes-0.11.7
	serde_derive-1.0.151
	serde_json-1.0.89
	signal-hook-registry-1.4.0
	siphasher-0.3.10
	slab-0.4.7
	smallvec-1.10.0
	socket2-0.4.7
	strsim-0.8.0
	syn-1.0.105
	system-deps-6.0.3
	termcolor-1.1.3
	textwrap-0.11.0
	thiserror-1.0.37
	thiserror-impl-1.0.37
	tokio-1.23.0
	tokio-io-0.1.13
	tokio-macros-1.8.2
	tokio-util-0.6.10
	toml-0.5.10
	ucd-trie-0.1.5
	unicode-ident-1.0.5
	unicode-segmentation-1.10.0
	unicode-width-0.1.10
	unix-daemonize-0.1.2
	vec_map-0.8.2
	version-compare-0.1.1
	version_check-0.9.4
	wasi-0.9.0+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.42.0
	windows_aarch64_gnullvm-0.42.0
	windows_aarch64_msvc-0.42.0
	windows_i686_gnu-0.42.0
	windows_i686_msvc-0.42.0
	windows_x86_64_gnu-0.42.0
	windows_x86_64_gnullvm-0.42.0
	windows_x86_64_msvc-0.42.0
	winres-0.1.12
"
inherit cargo xdg
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Lyude/${PN}.git"
else
	MY_PV="f048109"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/Lyude/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		$(cargo_crate_uris ${CRATES})
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="GTK UI for neovim written in rust using gtk-rs bindings"
HOMEPAGE="https://github.com/Lyude/${PN}"

LICENSE="GPL-3 MIT BSD LGPL-3"
SLOT="0"

DEPEND="
	gui-libs/gtk:4
"
RDEPEND="
	${DEPEND}
	app-editors/neovim
"

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_install() {
	dobin target/$(usex debug debug release)/nvim-gtk
	emake install-resources DESTDIR="${D}" PREFIX="${EPREFIX}/usr"
	einstalldocs
}
