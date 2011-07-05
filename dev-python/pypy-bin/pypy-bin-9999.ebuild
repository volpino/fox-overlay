# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pypy/pypy-1.5.ebuild,v 1.2 2011/06/24 09:18:38 djc Exp $

EAPI="2"

inherit eutils

DESCRIPTION="PyPy is a very compliant implementation of the Python language"
HOMEPAGE="http://pypy.org/"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+jit stackless"
RESTRICT="mirror"

MY_PN="pypy"
S="${WORKDIR}/pypy-c-*-linux*"

pkg_setup() {
	if use amd64 && use stackless ; then
		einfo
		ewarn "There's no binary available with stackless support for amd64"
		ewarn "architectures. \"stackless\" USE flag will be ignored"
	fi
	if use !amd64 && use jit && use stackless ; then
		einfo
		ewarn "You have enabled both the \"jit\" as well as the \"stackless\""
		ewarn "USE flags."
		ewarn "At the moment it is not possible to have pypy with support for"
		ewarn "the JIT compiler and both stackless."
		ewarn "JIT will be used in this case. If you want stackless support,"
		ewarn "unset the \"jit\" USE flag and leave only \"stackless\" set."
	fi
}

src_unpack() {
	if use amd64 ; then
		if use jit ; then
			SRC="pypy-c-jit-latest-linux64.tar.bz2"
		else
			SRC="pypy-c-nojit-latest-linux64.tar.bz2"
		fi
	elif use x86 ; then
		if use jit ; then
			SRC="pypy-c-jit-latest-linux.tar.bz2"
		elif use stackless ; then
			SRC="pypy-c-stackless-latest-linux.tar.bz2"
		else
			SRC="pypy-c-jit-latest-linux.tar.bz2"
		fi
	fi

	if [ -z "${FETCH_COMMAND}" ]; then
		MY_FETCH="wget"
	else
		MY_FETCH=${FETCH_COMMAND}
	fi
	${MY_FETCH} -O - "http://buildbot.pypy.org/nightly/trunk/${SRC}" | tar jxf -
}

src_install() {
	dodir /opt/${PN} || die 'dodir failed'
	insinto /opt/${PN}
	cd ${S} || die 'cd failed'
	doins -r ./* || die 'doins failed'
	fperms -w /opt/${PN}/bin/${MY_PN}
	fperms a+x /opt/${PN}/bin/${MY_PN}
	dosym /opt/${PN}/bin/${MY_PN} /usr/bin/${MY_PN} || die 'dosym failed'
	dodoc LICENSE
}

pkg_postinst() {
	ewarn "This is a live ebuild"
	ewarn "That means there are NO promises it will work."
}
